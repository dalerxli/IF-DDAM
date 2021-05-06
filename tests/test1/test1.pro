######################################################################
# Automatically generated by qmake (2.01a) Mon Dec 27 12:07:07 2010
######################################################################

TEMPLATE 	= 	app

VERSION         =       0.6.3

TARGET 		=       main

CONFIG          +=      warn_on debug

DEPENDPATH 	+= .

DEFINES 	+=      CDMVERSION=\\\"$$VERSION\\\"  DEBUG 
CONFIG(fftw) {
DEFINES 	+=      USE_FFTW
}
CONFIG(hdf5) {
DEFINES 	+=      USE_HDF5
}

QMAKE_CC        =       gfortran 

QMAKE_CFLAGS    += -Warray-bounds -w -cpp -mcmodel=large -fopenmp

QMAKE_LFLAGS    = -mcmodel=large -fopenmp

QMAKE_CFLAGS_RELEASE    = -O3 

QMAKE_CFLAGS_THREAD =

HEADERS 	+=      

SOURCES		+= 	mainsurf.f
                        
INCLUDEPATH 	+= .

CDMLIB_LIB_PATH  =      ../../cdmlib/lib

LIBS			+= -Wl,-rpath -Wl,$$CDMLIB_LIB_PATH -L$$CDMLIB_LIB_PATH -lcdmlibsurf \
					-lgfortran

CONFIG(fftw) {
	LIBS 		+= 	-lfftw3_omp -lfftw3 -lm 
}

CONFIG(hdf5) {
# sur centos, fedora, etc...
  exists( /usr/lib64/gfortran/modules ) {
	LIBS 		+= 	-I/usr/lib64/gfortran/modules -I/usr/include -L/usr/lib64 -lhdf5hl_fortran -lhdf5_hl -lhdf5_fortran -lhdf5
INCLUDEPATH     += /usr/lib64/gfortran/modules
  }
# sur ubuntu
  exists( /usr/include/hdf5/serial ) {
	LIBS 		+= 	-I/usr/include/hdf5/serial -I/usr/include -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lhdf5hl_fortran -lhdf5_hl -lhdf5_fortran -lhdf5
INCLUDEPATH     += /usr/include/hdf5/serial
QMAKE_CFLAGS    += -I/usr/include/hdf5/serial
  }
} else {
	LIBS 		+= 	
}
