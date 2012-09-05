local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms.mpi.openmpi",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module

-------------------------------------------------------------------------------

local G = _G
local _getenv = os.getenv
local _pcall = pcall
local _assert = assert
local _print = print

-------------------------------------------------------------------------------
--- <p><b>Module:</b> OpenMPI declarations. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------


-- get rank and size
function detect(m)
   m.rank = _getenv("OMPI_COMM_WORLD_RANK")
   m.size = _getenv("OMPI_COMM_WORLD_SIZE")
   return m.size ~= nil
end

-- inject definitions
function inject(m)

   -- bind to MPI library

   local ok, l = _pcall( ffi.load, "mpi", true )		   
   _assert(ok, "failed to bind to MPI (openmpi) library") 
   m.lib = l

   -- declarations

   ffi.cdef[[

	 struct ompi_status_public_t {

	    /* public */
	    int MPI_SOURCE;
	    int MPI_TAG;
	    int MPI_ERROR;
	    /* internal */
	    int _cancelled;
	    size_t _ucount;
	 };

	 // type pointers

	 typedef ptrdiff_t MPI_Aint;
	 typedef long long MPI_Offset;
	 typedef struct ompi_fortran_integer_t MPI_Fint;
	 typedef struct ompi_communicator_t *MPI_Comm; 
	 typedef struct ompi_datatype_t *MPI_Datatype;
	 typedef struct ompi_errhandler_t *MPI_Errhandler;
	 typedef struct ompi_file_t *MPI_File;
	 typedef struct ompi_group_t *MPI_Group;
	 typedef struct ompi_info_t *MPI_Info;
	 typedef struct ompi_op_t *MPI_Op;
	 typedef struct ompi_request_t *MPI_Request;
	 typedef struct ompi_status_public_t MPI_Status;
	 typedef struct ompi_win_t *MPI_Win;

	 // null handlers

	 extern struct ompi_group_t ompi_mpi_group_null;
	 extern struct ompi_communicator_t ompi_mpi_comm_null;
	 extern struct ompi_request_t ompi_request_null;
	 extern struct ompi_op_t ompi_mpi_op_null;
 	 extern struct ompi_errhandler_t ompi_mpi_errhandler_null;
	 extern struct ompi_info_t ompi_mpi_info_null;
	 extern struct ompi_win_t ompi_mpi_win_null;
	 extern struct ompi_file_t ompi_mpi_file_null;
	 
	 // predefined handlers

	 extern struct ompi_communicator_t ompi_mpi_comm_world;
	 extern struct ompi_communicator_t ompi_mpi_comm_self;
	 extern struct ompi_group_t ompi_mpi_group_empty;

	 // operators

	 extern struct ompi_op_t ompi_mpi_op_min;
	 extern struct ompi_op_t ompi_mpi_op_max;
	 extern struct ompi_op_t ompi_mpi_op_sum;
	 extern struct ompi_op_t ompi_mpi_op_prod;
	 extern struct ompi_op_t ompi_mpi_op_land;
	 extern struct ompi_op_t ompi_mpi_op_band;
	 extern struct ompi_op_t ompi_mpi_op_lor;
	 extern struct ompi_op_t ompi_mpi_op_bor;
	 extern struct ompi_op_t ompi_mpi_op_lxor;
	 extern struct ompi_op_t ompi_mpi_op_bxor;
	 extern struct ompi_op_t ompi_mpi_op_maxloc;
	 extern struct ompi_op_t ompi_mpi_op_minloc;
	 extern struct ompi_op_t ompi_mpi_op_replace;
	 
	 // datatypes (omitted fortran, cxx and some misc types)

	 extern struct ompi_datatype_t ompi_mpi_datatype_null;
	 extern struct ompi_datatype_t ompi_mpi_char;
	 extern struct ompi_datatype_t ompi_mpi_signed_char;
	 extern struct ompi_datatype_t ompi_mpi_unsigned_char;
	 extern struct ompi_datatype_t ompi_mpi_byte;
	 extern struct ompi_datatype_t ompi_mpi_short;
	 extern struct ompi_datatype_t ompi_mpi_unsigned_short;
	 extern struct ompi_datatype_t ompi_mpi_int;
	 extern struct ompi_datatype_t ompi_mpi_unsigned;
	 extern struct ompi_datatype_t ompi_mpi_long;
	 extern struct ompi_datatype_t ompi_mpi_unsigned_long;
	 extern struct ompi_datatype_t ompi_mpi_long_long_int;
	 extern struct ompi_datatype_t ompi_mpi_unsigned_long_long;
	 extern struct ompi_datatype_t ompi_mpi_float;
	 extern struct ompi_datatype_t ompi_mpi_double;
	 extern struct ompi_datatype_t ompi_mpi_long_double;
	 extern struct ompi_datatype_t ompi_mpi_wchar;
	 extern struct ompi_datatype_t ompi_mpi_packed;
	 extern struct ompi_datatype_t ompi_mpi_short_int;
	 extern struct ompi_datatype_t ompi_mpi_long_int;
	 extern struct ompi_datatype_t ompi_mpi_int8_t;
	 extern struct ompi_datatype_t ompi_mpi_uint8_t;
	 extern struct ompi_datatype_t ompi_mpi_int16_t;
	 extern struct ompi_datatype_t ompi_mpi_uint16_t;
	 extern struct ompi_datatype_t ompi_mpi_int32_t;
	 extern struct ompi_datatype_t ompi_mpi_uint32_t;
	 extern struct ompi_datatype_t ompi_mpi_int64_t;
	 extern struct ompi_datatype_t ompi_mpi_uint64_t;
	 extern struct ompi_datatype_t ompi_mpi_aint;
	 extern struct ompi_datatype_t ompi_mpi_offset;
	 extern struct ompi_datatype_t ompi_mpi_c_bool;
	 extern struct ompi_datatype_t ompi_mpi_c_complex;
	 extern struct ompi_datatype_t ompi_mpi_c_float_complex;
	 extern struct ompi_datatype_t ompi_mpi_c_double_complex;
	 extern struct ompi_datatype_t ompi_mpi_c_long_double_complex;

	 // error policies

	 extern struct ompi_errhandler_t ompi_mpi_errors_are_fatal;
	 extern struct ompi_errhandler_t ompi_mpi_errors_return;
	
   ]]

   -- null handlers

   m.MPI_GROUP_NULL = l.ompi_mpi_group_null
   m.MPI_COMM_NULL = l.ompi_mpi_comm_null
   m.MPI_REQUEST_NULL = l.ompi_request_null
   m.MPI_OP_NULL = l.ompi_mpi_op_null
   m.MPI_ERRHANDLER_NULL = l.ompi_mpi_errhandler_null
   m.MPI_INFO_NULL = l.ompi_mpi_info_null
   m.MPI_WIN_NULL = l.ompi_mpi_win_null
   m.MPI_FILE_NULL = l.ompi_mpi_file_null
   m.MPI_STATUS_IGNORE = ffi.cast("MPI_Status*",0)
   MPI_STATUSES_IGNORE = ffi.cast("MPI_Status*",0)

   -- predefined handlers

   m.MPI_COMM_WORLD = l.ompi_mpi_comm_world
   m.MPI_COMM_SELF = l.ompi_mpi_comm_self
   m.MPI_GROUP_EMPTY = l.ompi_mpi_group_empty

   -- operators

   m.MPI_MAX = l.ompi_mpi_op_max
   m.MPI_MIN = l.ompi_mpi_op_min
   m.MPI_SUM = l.ompi_mpi_op_sum
   m.MPI_PROD = l.ompi_mpi_op_prod
   m.MPI_LAND = l.ompi_mpi_op_land
   m.MPI_BAND = l.ompi_mpi_op_band
   m.MPI_LOR = l.ompi_mpi_op_lor
   m.MPI_BOR = l.ompi_mpi_op_bor
   m.MPI_LXOR = l.ompi_mpi_op_lxor
   m.MPI_BXOR = l.ompi_mpi_op_bxor
   m.MPI_MAXLOC = l.ompi_mpi_op_maxloc
   m.MPI_MINLOC = l.ompi_mpi_op_minloc
   m.MPI_REPLACE = l.ompi_mpi_op_replace

   -- datatypes
   
   m.MPI_DATATYPE_NULL = l.ompi_mpi_datatype_null
   m.MPI_BYTE = l.ompi_mpi_byte
   m.MPI_PACKED = l.ompi_mpi_packed
   m.MPI_CHAR = l.ompi_mpi_char
   m.MPI_SHORT = l.ompi_mpi_short
   m.MPI_INT = l.ompi_mpi_int
   m.MPI_LONG = l.ompi_mpi_long
   m.MPI_FLOAT = l.ompi_mpi_float
   m.MPI_DOUBLE = l.ompi_mpi_double
   m.MPI_LONG_DOUBLE = l.ompi_mpi_long_double
   m.MPI_UNSIGNED_CHAR = l.ompi_mpi_unsigned_char
   m.MPI_SIGNED_CHAR = l.ompi_mpi_signed_char
   m.MPI_UNSIGNED_SHORT = l.ompi_mpi_unsigned_short
   m.MPI_UNSIGNED_LONG = l.ompi_mpi_unsigned_long
   m.MPI_UNSIGNED = l.ompi_mpi_unsigned
   m.MPI_LONG_INT = l.ompi_mpi_long_int
   m.MPI_SHORT_INT = l.ompi_mpi_short_int
   m.MPI_WCHAR = l.ompi_mpi_wchar
   m.MPI_LONG_LONG_INT = l.ompi_mpi_long_long_int
   m.MPI_LONG_LONG = l.ompi_mpi_long_long_int
   m.MPI_UNSIGNED_LONG_LONG = l.ompi_mpi_unsigned_long_long
   m.MPI_INT8_T = l.ompi_mpi_int8_t
   m.MPI_UINT8_T= l.ompi_mpi_uint8_t
   m.MPI_INT16_T= l.ompi_mpi_int16_t
   m.MPI_UINT16_T = l.ompi_mpi_uint16_t
   m.MPI_INT32_T= l.ompi_mpi_int32_t
   m.MPI_UINT32_T = l.ompi_mpi_uint32_t
   m.MPI_INT64_T= l.ompi_mpi_int64_t
   m.MPI_UINT64_T = l.ompi_mpi_uint64_t
   m.MPI_AINT = l.ompi_mpi_aint
   m.MPI_OFFSET = l.ompi_mpi_offset
   m.MPI_C_BOOL = l.ompi_mpi_c_bool
   m.MPI_C_COMPLEX = l.ompi_mpi_c_complex
   m.MPI_C_FLOAT_COMPLEX = l.ompi_mpi_c_float_complex
   m.MPI_C_DOUBLE_COMPLEX = l.ompi_mpi_c_double_complex
   m.MPI_C_LONG_DOUBLE_COMPLEX = l.ompi_mpi_c_long_double_complex
   
   -- error policy

   m.MPI_ERRORS_ARE_FATAL = l.ompi_mpi_errors_are_fatal
   m.MPI_ERRORS_RETURN = l.ompi_mpi_errors_return

   -- error table

   m.errtab = {}
   local errtab = m.errtab
   errtab.MPI_SUCCESS=                   0
   errtab.MPI_ERR_BUFFER=                1
   errtab.MPI_ERR_COUNT=                 2
   errtab.MPI_ERR_TYPE=                  3
   errtab.MPI_ERR_TAG=                   4
   errtab.MPI_ERR_COMM=                  5
   errtab.MPI_ERR_RANK=                  6
   errtab.MPI_ERR_REQUEST=               7
   errtab.MPI_ERR_ROOT=                  8
   errtab.MPI_ERR_GROUP=                 9
   errtab.MPI_ERR_OP=                    10
   errtab.MPI_ERR_TOPOLOGY=              11
   errtab.MPI_ERR_DIMS=                  12
   errtab.MPI_ERR_ARG=                   13
   errtab.MPI_ERR_UNKNOWN=               14
   errtab.MPI_ERR_TRUNCATE=              15
   errtab.MPI_ERR_OTHER=                 16
   errtab.MPI_ERR_INTERN=                17
   errtab.MPI_ERR_IN_STATUS=             18
   errtab.MPI_ERR_PENDING=               19
   errtab.MPI_ERR_ACCESS=                20
   errtab.MPI_ERR_AMODE=                 21
   errtab.MPI_ERR_ASSERT=                22
   errtab.MPI_ERR_BAD_FILE=              23
   errtab.MPI_ERR_BASE=                  24
   errtab.MPI_ERR_CONVERSION=            25
   errtab.MPI_ERR_DISP=                  26
   errtab.MPI_ERR_DUP_DATAREP=           27
   errtab.MPI_ERR_FILE_EXISTS=           28
   errtab.MPI_ERR_FILE_IN_USE=           29
   errtab.MPI_ERR_FILE=                  30
   errtab.MPI_ERR_INFO_KEY=              31
   errtab.MPI_ERR_INFO_NOKEY=            32
   errtab.MPI_ERR_INFO_VALUE=            33
   errtab.MPI_ERR_INFO=                  34
   errtab.MPI_ERR_IO=                    35
   errtab.MPI_ERR_KEYVAL=                36
   errtab.MPI_ERR_LOCKTYPE=              37
   errtab.MPI_ERR_NAME=                  38
   errtab.MPI_ERR_NO_MEM=                39
   errtab.MPI_ERR_NOT_SAME=              40
   errtab.MPI_ERR_NO_SPACE=              41
   errtab.MPI_ERR_NO_SUCH_FILE=          42
   errtab.MPI_ERR_PORT=                  43
   errtab.MPI_ERR_QUOTA=                 44
   errtab.MPI_ERR_READ_ONLY=             45
   errtab.MPI_ERR_RMA_CONFLICT=          46
   errtab.MPI_ERR_RMA_SYNC=              47
   errtab.MPI_ERR_SERVICE=               48
   errtab.MPI_ERR_SIZE=                  49
   errtab.MPI_ERR_SPAWN=                 50
   errtab.MPI_ERR_UNSUPPORTED_DATAREP=   51
   errtab.MPI_ERR_UNSUPPORTED_OPERATION= 52
   errtab.MPI_ERR_WIN=                   53
   errtab.MPI_ERR_LASTCODE=              54
   errtab.MPI_ERR_SYSRESOURCE=          -2

   -- misc constants

   local OPAL_MAX_DATAREP_STRING= 128
   local OPAL_MAX_ERROR_STRING= 256
   local OPAL_MAX_INFO_KEY= 36
   local OPAL_MAX_INFO_VAL= 256
   local OPAL_MAX_OBJECT_NAME= 64
   local OPAL_MAX_PORT_NAME= 1024
   local OPAL_MAX_PROCESSOR_NAME= 256

   m.MPI_ANY_SOURCE=         -1
   m.MPI_PROC_NULL=          -2
   m.MPI_ROOT=               -4
   m.MPI_ANY_TAG=            -1
   m.MPI_MAX_PROCESSOR_NAME= OPAL_MAX_PROCESSOR_NAME
   m.MPI_MAX_ERROR_STRING=   OPAL_MAX_ERROR_STRING
   m.MPI_MAX_OBJECT_NAME=    OPAL_MAX_OBJECT_NAME
   m.MPI_UNDEFINED=          -32766
   m.MPI_CART=               1
   m.MPI_GRAPH=              2
   m.MPI_KEYVAL_INVALID=     -1

   m.MPI_BOTTOM= ffi.cast("void *",0) 
   m.MPI_IN_PLACE= ffi.cast("void *",1)
   m.MPI_BSEND_OVERHEAD=       128
   m.MPI_MAX_INFO_KEY=         OPAL_MAX_INFO_KEY
   m.MPI_MAX_INFO_VAL=         OPAL_MAX_INFO_VAL
   m.MPI_ARGV_NULL=            ffi.cast("char**",0)
   m.MPI_ARGVS_NULL=           ffi.cast("char ***", 0)
   m.MPI_ERRCODES_IGNORE=      ffi.cast("int *", 0)
   m.MPI_MAX_PORT_NAME=        OPAL_MAX_PORT_NAME
   m.MPI_MAX_NAME_LEN=         MPI_MAX_PORT_NAME
   m.MPI_ORDER_C=              0
   m.MPI_ORDER_FORTRAN=        1
   m.MPI_DISTRIBUTE_BLOCK=     0
   m.MPI_DISTRIBUTE_CYCLIC=    1
   m.MPI_DISTRIBUTE_NONE=      2
   m.MPI_DISTRIBUTE_DFLT_DARG= (-1)

   m.MPI_MODE_CREATE           =   1
   m.MPI_MODE_RDONLY           =   2
   m.MPI_MODE_WRONLY           =   4
   m.MPI_MODE_RDWR             =   8
   m.MPI_MODE_DELETE_ON_CLOSE  =  16
   m.MPI_MODE_UNIQUE_OPEN      =  32
   m.MPI_MODE_EXCL             =  64
   m.MPI_MODE_APPEND           = 128
   m.MPI_MODE_SEQUENTIAL       = 256
   
   m.MPI_DISPLACEMENT_CURRENT  = -54278278
   
   m.MPI_SEEK_SET              = 600
   m.MPI_SEEK_CUR              = 602
   m.MPI_SEEK_END              = 604
   
   m.MPI_MAX_DATAREP_STRING= OPAL_MAX_DATAREP_STRING 

   m.MPI_MODE_NOCHECK           =  1
   m.MPI_MODE_NOPRECEDE         =  2
   m.MPI_MODE_NOPUT             =  4
   m.MPI_MODE_NOSTORE           =  8
   m.MPI_MODE_NOSUCCEED         = 16
   
   m.MPI_LOCK_EXCLUSIVE         =  1
   m.MPI_LOCK_SHARED            =  2
   
   m.MPI_TAG_UB = 0
   m.MPI_HOST = 1
   m.MPI_IO = 2
   m.MPI_WTIME_IS_GLOBAL = 3
   m.MPI_APPNUM = 4
   m.MPI_LASTUSEDCODE = 5
   m.MPI_UNIVERSE_SIZE = 6
   m.MPI_WIN_BASE = 7
   m.MPI_WIN_SIZE = 8
   m.MPI_WIN_DISP_UNIT = 9
   m.IMPI_CLIENT_SIZE = 10
   m.IMPI_CLIENT_COLOR = 11
   m.IMPI_HOST_SIZE = 12
   m.IMPI_HOST_COLOR = 13

  m.MPI_IDENT = 0
  m.MPI_CONGRUENT= 1
  m.MPI_SIMILAR = 2
  m.MPI_UNEQUAL = 3

  m.MPI_THREAD_SINGLE = 0
  m.MPI_THREAD_FUNNELED = 1
  m.MPI_THREAD_SERIALIZED = 2
  m.MPI_THREAD_MULTIPLE = 3

  m.MPI_COMBINER_NAMED = 0
  m.MPI_COMBINER_DUP = 1
  m.MPI_COMBINER_CONTIGUOUS = 2
  m.MPI_COMBINER_VECTOR = 3
  m.MPI_COMBINER_HVECTOR_INTEGER = 4
  m.MPI_COMBINER_HVECTOR = 5
  m.MPI_COMBINER_INDEXED = 6
  m.MPI_COMBINER_HINDEXED_INTEGER = 7
  m.MPI_COMBINER_HINDEXED = 8
  m.MPI_COMBINER_INDEXED_BLOCK = 9
  m.MPI_COMBINER_STRUCT_INTEGER = 10
  m.MPI_COMBINER_STRUCT = 11
  m.MPI_COMBINER_SUBARRAY = 12
  m.MPI_COMBINER_DARRAY = 13
  m.MPI_COMBINER_F90_REAL = 14
  m.MPI_COMBINER_F90_COMPLEX = 15
  m.MPI_COMBINER_F90_INTEGER = 16
  m.MPI_COMBINER_RESIZED = 17

end

------------------------------------------------------------------------------
