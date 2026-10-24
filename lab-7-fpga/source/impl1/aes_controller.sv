module aes_controller(
  input  logic clk,
  input  logic load,

  // Set by the controller when the encryption process is finished
  output logic done,

  /*
  Whether the datapath should update its state (the ciphertext state vector and round key value) on the next clock cycle
  Since some operations require multiple clock cycles to perform, we don't want to prematurely update the state while the operation is still ongoing
  */
  output logic state_update,

  /*
  When the datapath updates its state, indicates where the next state should come from
  For the ciphertext state vector:
    0 = load next state from the output of the previous round
    1 = load next state from the plaintext input
  For the round key value:
    0 = load next state from the previous round keys
    1 = load next state from the key input
  */
  output logic state_select,

  // Needed to compute key_expansion_step, and changes every round
  output logic [31:0] round_const,

  /*
  Whether the datapath should skip all the other steps and only add the round key
  Also controls whether add_round_key should load the round key from the provided key itself or from the output of key_expansion_step
  This happens during round 0 of AES
  */
  output logic only_add_round_key,

  // Whether the datapath should skip the mix_columns step
  output logic skip_mix_columns
);
  // State encoding
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    CIPHER = 2'b10,
    DONE = 2'b11
  } state_t;
  state_t state = IDLE;

  // State variables
  logic start_cipher; // flag to start the cipher when the load signal experiences a falling edge
  logic [3:0] cycle_latency = 0; // used to time operations that require multiple clock cycles of latency
  logic [3:0] round_num = 0; // current round number of AES, round 0 starts before any of the normal rounds  
  falling_edge_detector ld(.clk, .q(load), .trigger(start_cipher));

  // Next state logic
  always_ff @(posedge clk) begin
    if (state == IDLE && start_cipher) begin
      state <= CIPHER;
      cycle_latency <= 1;
    end
    else if (state == CIPHER) begin
      if (cycle_latency == 0) begin
        if (round_num >= 10) state <= DONE;
        else begin
          cycle_latency <= 1;
          round_num <= round_num + 1;
        end
      end
      else cycle_latency <= cycle_latency - 1;
    end
  end

  // Output logic
  always_comb begin
    // Let the top-level module know when the encryption is complete
    done = (state == DONE);

    /*
    There are two cases when we should update the state:

    1. We are waiting for the cipher to start and become notified that the data is ready. In this case we should load the plaintext and key inputs as the initial state in the datapath
    
    2. During a round of AES when the clock cycle latency reaches 0. This indicates that the current round has finished computing the next state, so we should update it on the next clock cycle
    */
    state_update = (state == IDLE && start_cipher) || (state == CIPHER && cycle_latency == 0);

    // We only load external inputs into the state when starting the cipher
    state_select = (state == IDLE && start_cipher);

    // Change the value of round_const every round, according to the spec
    case (round_num)
      1:       round_const = 32'h01000000;
      2:       round_const = 32'h02000000;
      3:       round_const = 32'h04000000;
      4:       round_const = 32'h08000000;
      5:       round_const = 32'h10000000;
      6:       round_const = 32'h20000000;
      7:       round_const = 32'h40000000;
      8:       round_const = 32'h80000000;
      9:       round_const = 32'h1b000000;
      10:      round_const = 32'h36000000;
      default: round_const = 0;
    endcase

    // During round 0, we only add the round key (which is just the provided key) to the state
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
  logic q_prev;

  always_ff @(posedge clk) begin
    q_prev <= q;
  end

  assign trigger = q_prev & ~q;
endmodule