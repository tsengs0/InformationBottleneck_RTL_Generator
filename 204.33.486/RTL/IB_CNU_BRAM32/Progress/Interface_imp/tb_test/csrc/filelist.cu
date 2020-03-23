PIC_LD=ld

ARCHIVE_OBJS=
ARCHIVE_OBJS += _23013_archive_1.so
_23013_archive_1.so : archive.0/_23013_archive_1.a
	@$(AR) -s $<
	@$(PIC_LD) -shared  -o .//../tb.daidir//_23013_archive_1.so --whole-archive $< --no-whole-archive
	@rm -f $@
	@ln -sf .//../tb.daidir//_23013_archive_1.so $@






%.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

MAIN_OBJS = \
objs/amcQw_d.o 

CU_OBJS = $(MAIN_OBJS) $(ARCHIVE_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

