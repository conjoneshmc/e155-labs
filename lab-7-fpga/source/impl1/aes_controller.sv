module aes_controller(
  input  logic clk,
  input  logic load,
  output logic done,
  output logic load_inputs,
  output logic load_words,
  output logic load_cipher_state,
  output logic cipher_state_sel,
  output logic only_add_round_key,
  output logic skip_mix_columns,
  output logic [3:0] round_num = 0
);
  // State encoding
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    KEY_EXPANSION = 2'b01,
    CIPHER = 2'b10,
    DONE = 2'b11
  } state_t;
  state_t state = IDLE;
  logic [3:0] cycle_latency = 0; // used to time operations that require multiple clock cycles of latency

  // When the module is ready to start, load will transition from high to low
  falling_edge_detector ld(.clk, .q(load), .trigger(load_inputs));

  // Next state logic
  always_ff @(posedge clk) begin
    if (state == IDLE && load_inputs) begin
      state <= KEY_EXPANSION;
      cycle_latency <= 10; // key_expansion needs 10 clock cycles to do its thing
    end
    else if (state == KEY_EXPANSION) begin
      if (cycle_latency == 0) begin
        state <= CIPHER;
        cycle_latency <= 0; // the "zeroth" round of AES only adds the round key and does not require a clock cycle
        round_num <= 0;
      end
      else begin
        cycle_latency <= cycle_latency - 1;
      end
    end
    else if (state == CIPHER) begin
      if (round_num >= 10 && cycle_latency == 0) begin
        state <= DONE;
      end
      else if (cycle_latency == 0) begin
        cycle_latency <= 1;
        round_num <= round_num + 1;
      end
      else begin
        cycle_latency <= cycle_latency - 1;
      end
    end
  end

  // Output logic
  always_comb begin
    // Let the top-level module know when the encryption is complete
    done = (state == DONE);

    // load_inputs is driven by the falling edge detector

    // Tells the datapath to clock the output of the key_expansion module after it's done
    load_words = (state == KEY_EXPANSION) && (cycle_latency == 0);

    // Tells the datapath to update the state vector after key expansion and after each round is done
    // Each round takes 2 cycles of latency to complete, since sub_bytes is clocked to DRAM
    // In that case, we don't want to overwrite the state vector before sub_bytes is finished
    load_cipher_state = (state == KEY_EXPANSION || state == CIPHER) && (cycle_latency == 0);

    // Tells the datapath whether to load the state vector from the plaintext input or from the output
    // of the previous round
    // A value of 1 means the state vector should get the value of the plaintext
    // A value of 0 means the state vector should get the output from the previous round
    cipher_state_sel = (state == KEY_EXPANSION) && (cycle_latency == 0);

    // Before any of the rounds start, we only add the round key to the state
    only_add_round_key = (state == CIPHER) && (round_num == 0);

    // During the last round, we skip the mix columns step
    skip_mix_columns = (state == CIPHER) && (round_num == 10);
  end
endmodule


module falling_edge_detector(
  input  logic clk,
  input  logic q,
  output logic trigger
);
  // Helper module for detecting a falling edge on the load signal, indicating the encryption is ready to start
  logic q_prev;
  always_ff @(posedge clk) begin
    q_prev <= q;
  end
  assign trigger = q_prev & ~q;
endmodule