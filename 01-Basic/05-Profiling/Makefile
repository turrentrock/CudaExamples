NVCC := nvcc 
MAKE ?= make

LIBS :=  #-lcurand

NVCCFLAGS := -I. \
			 -I/usr/local/cuda/include \
			 -dlink

BUILT_LIBS := 

LDFLAGS += #$(shell pkg-config opencv --cflags --libs)

OBJS := *.o 

all:
	$(MAKE) app

app:
	$(NVCC) $(NVCCFLAGS) -dc main.cu $(LDFLAGS)
	$(NVCC) $(OBJS) $(LIBS) $(BUILT_LIBS) -o run $(LDFLAGS)

app-debug:
	$(NVCC) -DUNIT_TEST $(NVCCFLAGS) -dc main.cu $(LDFLAGS)
	$(NVCC) $(OBJS) $(LIBS) $(BUILT_LIBS) -o run $(LDFLAGS)

clean:
	rm -f run
	rm -f *.o
	rm -f *.a