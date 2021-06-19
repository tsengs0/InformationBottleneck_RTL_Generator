import read_vnu_lut as vnu3

# The variable node opeartion for reference of RTL testbench
def vnu3_operation_sw(ch_msg, c2v_in, iter):
    v2c_out = vnu3.cascaded_vnu3_sym_sw(iter, c2v_in, ch_msg, log_wr_en=0)

    return v2c_out

def main():
    c2v_in = [2, 1, 12]
    ch_msg = int(14)
    iter = 24

    v2c_out = vnu3_operation_sw(ch_msg, c2v_in, iter)
    print("Iter_", iter, "\tc2v_in: ", c2v_in, ", ch_msg: ", ch_msg, "-> v2c_out: ", v2c_out)

if __name__ == "__main__":
    main()
ib_10_layered_loc_min-lut_2.2_444_123_1000_az.json
python_prj
qc_3_10_765_girth_10_True_seed_100.json
RTL
ib_10_layered_loc_min-lut_2.2_444_123_1000_az.json
