#include "../inc/shift_ctrl.hpp"

#define L1PA_REGFILE_NAME  "config/l1pa_spr_5_gp2Num3_gp2Alloc10101.csv";
unsigned short *colBankID_gp2;

shift_control_unit::shift_control_unit(
    unsigned short *colBankID_gp2_config
) {
    colBankID_gp2 = colBankID_gp2_config;
    
    // To load the shift-pattern file for L1PA shift register file
    std::string config_filename = (std::string) L1PA_REGFILE_NAME;
    std::string str_buf;
    std::string str_conma_buf;
    unsigned short line_cnt, text_cnt, page_cnt;
    unsigned short patternID, seq_element_id;
    short l1pa_spr, shift_temp0, shift_temp1;
    std::string gp2_rqst_pattern;
    
    line_cnt = 0;
    std::ifstream ifs_csv_file(config_filename);

    if(!ifs_csv_file.is_open()) {
        std::cout << "Failed to open the configuration file: " 
                  << config_filename << std::endl;
        exit(1);
    } else {
        while (getline(ifs_csv_file, str_buf)) {    
            // To read string with separator of comma
            std::istringstream i_stream(str_buf);
            if(line_cnt == 0) {
                // Doing nothing at the header line
            } else { // To start read the line of csv file from the second line
                text_cnt = 0;
                while (getline(i_stream, str_conma_buf, ',')) {
                    if(text_cnt == PATTERN_ID)
                        patternID = (unsigned short) std::stoi(str_conma_buf);
                    else if(text_cnt == GP2_RQST_PATTERN) 
                        gp2_rqst_pattern = str_conma_buf;
                    else if(text_cnt == L1PA_SPR) 
                        l1pa_spr = (short) std::stoi(str_conma_buf);
                    else if(text_cnt == SEQ_ELEMENT_ID) {
                        seq_element_id = (unsigned short) std::stoi(str_conma_buf);
                        
                    }
                    else {
                        std::cout << "Exception from the text counting" << std::endl;
                        exit(1);
                    }
                    text_cnt = (text_cnt == SEQ_ELEMENT_ID) ? 0 : text_cnt+1;
                    //ofs_csv_file << str_conma_buf << ',';
                }
            }
            // To load the read contents into the L1PA shift regFile
            if(line_cnt == 1) {
                page_cnt = 0;
                shiftCtrl_regfile.push_back({(short) l1pa_spr, (short) 0, false});
            } else if(line_cnt >= 1) {
                if(seq_element_id != 0) {
                    shift_temp0 = shiftCtrl_regfile[patternID].l1pa_shift;
                    shift_temp1 = l1pa_spr;
                    shiftCtrl_regfile[patternID].l1pa_delta = (shift_temp0 >= shift_temp1) ? shift_temp0-shift_temp1 : shift_temp1-shift_temp0;
                    shiftCtrl_regfile[patternID].isGtr = true;
                } else { // seq_element_id == 0
                    shiftCtrl_regfile.push_back({(short) l1pa_spr, (short) 0, false});
                }
            }
            page_cnt += 1;
            line_cnt += 1;
        }
    }

    // To register the header of each FSM state for ease of debugging
    fsm_state_header[IDLE] = "IDLE";
    fsm_state_header[COL_ADDR_ARRIVAL] = "COL_ADDR_ARRIVAL";
    fsm_state_header[READ_COL_ADDR] = "READ_COL_ADDR";
    fsm_state_header[SHIFT_GEN] = "SHIFT_GEN";
    fsm_state_header[SHIFT_OUT] = "SHIFT_OUT";
}
//==============================================================
// Attempt of FSM update for the given request
// Note that the updated FSM state of the request will not be 
// committed in this function. Instead, any update ought to be
// judged by a subsequent resource arbiter in order to finally 
// committed the FSM states for all contended resource requests
//==============================================================
shiftCtrl_state shift_control_unit::fsm_update(
    bool is_active, 
    shiftCtrl_state fsm_state, 
    unsigned short rqstID
) {
    switch(fsm_state) {
        case IDLE:
            fsm_state = (is_active == true) ? COL_ADDR_ARRIVAL : IDLE;
            break;
        case COL_ADDR_ARRIVAL:
            fsm_state = READ_COL_ADDR;
            break;
        case READ_COL_ADDR:
            fsm_state = SHIFT_GEN;
            break;
        case SHIFT_GEN:
            fsm_state = SHIFT_OUT;
            break;
        case SHIFT_OUT:
            // To deal with the pipelining behaviour
            fsm_state = (is_active == true) ? COL_ADDR_ARRIVAL : IDLE;
            break;
        default:
            fsm_state = IDLE;
            break;
    }

    return fsm_state;
}

void shift_control_unit::fsm_process(unsigned short fsm_state)
{
    switch(fsm_state) {
        case COL_ADDR_ARRIVAL:
            //col_addr_receive();
            break;
        case READ_COL_ADDR:
            col_addr_read();
            break;
        case SHIFT_GEN:
            shift_gen();
            break;
        case SHIFT_OUT:
            //shift_out();
            break;
        default:
            // IDLE
            break;
    }
}

void shift_control_unit::col_addr_receive(unsigned short *col_addr_in)
{
    // Step 1: col_addr-to-R^{gp2} converter
    rqst_gp2 = 0;
    for(int i=0; i<SHARE_GP_NUM; i++) {
        for(int j=0; j<SHARE_GP_NUM; j++) {
            if(col_addr_in[i] == colBankID_gp2[j]) {
                rqst_gp2 |= (0x1) << i;
                break;
            }
        }
    }

    // Step 2: R^{gp2}-to-regFile_addr
    regFile_IF.raddr_i = rqst_gp2;
}

void shift_control_unit::show_regfile()
{
    std::cout << "=========================================================" << std::endl
              << "W^{s}: " << SHARE_GP_NUM << std::endl;
    std::cout << "regfile.size: " << shiftCtrl_regfile.size() << std::endl;
    for(int i=0; i<shiftCtrl_regfile.size(); i++) {
            printf("Addr: 0x%02X\t", i);
            std::cout << "Shift: " << shiftCtrl_regfile[i].l1pa_shift << ",\t"
                      << "Delta: " << shiftCtrl_regfile[i].l1pa_delta << ",\t"
                      << "isGtr: " << shiftCtrl_regfile[i].isGtr << std::endl;
    }
    std::cout << "=========================================================" << std::endl;
}

void shift_control_unit::col_addr_read()
{
    regFile_IF.page_out = shiftCtrl_regfile[regFile_IF.raddr_i];
}

void shift_control_unit::shift_gen()
{
    shift_gen_out[0] = regFile_IF.page_out.l1pa_shift;
    shift_gen_out[1] = regFile_IF.page_out.l1pa_shift+regFile_IF.page_out.l1pa_delta;
}

short shift_control_unit::shift_out(unsigned short alloc_cycle_id)
{
    return (alloc_cycle_id == 0) ? shift_gen_out[0] : shift_gen_out[1];
}