local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms.mpi.lam",
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
--- <p><b>Module:</b> LAM/MPI declarations. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------


-- get rank and size
function detect(m)
   local v1 = _getenv("LAMKENYAPID")
   local v2 = _getenv("LAMJOBID")
   local v3 = _getenv("LAMPARENT")
   m.rank = _getenv("LAMRANK")
   m.size = _getenv("LAMWORLD")
   return v1 and v2 and v3 and m.size and m.rank
end

-- inject definitions
function inject(m)

  l = m.lib
  
   -- declarations

   ffi.cdef[[

	 // status

	 struct _status { 
	    int		MPI_SOURCE;
	    int		MPI_TAG;
	    int		MPI_ERROR;
	    int		st_length;		/* message length */
	 };

	 // type pointers

	 typedef struct _status		MPI_Status;
	 typedef struct _group		*MPI_Group;
	 typedef struct _comm		*MPI_Comm;
	 typedef struct _dtype		*MPI_Datatype;
	 typedef struct _req		*MPI_Request;
	 typedef struct _op		*MPI_Op;
	 typedef struct _errhdl		*MPI_Errhandler;
	 typedef struct _info		*MPI_Info;
	 typedef struct _window		*MPI_Win;
	 typedef void			*MPI_Buffer;
	 typedef long			MPI_Aint;
	 typedef int			MPI_Fint;
//	 typedef long long MPI_Offset;  lam is missing this
	 
	 // predefined handlers

	 extern struct _comm lam_mpi_comm_world;
	 extern struct _comm lam_mpi_comm_self;
	 extern struct _group lam_mpi_group_empty;

	 // operators

	 extern struct _op lam_mpi_min;
	 extern struct _op lam_mpi_max;
	 extern struct _op lam_mpi_sum;
	 extern struct _op lam_mpi_prod;
	 extern struct _op lam_mpi_land;
	 extern struct _op lam_mpi_band;
	 extern struct _op lam_mpi_lor;
	 extern struct _op lam_mpi_bor;
	 extern struct _op lam_mpi_lxor;
	 extern struct _op lam_mpi_bxor;
	 extern struct _op lam_mpi_maxloc;
	 extern struct _op lam_mpi_minloc;
	 extern struct _op lam_mpi_replace;
	 
	 // datatypes (omit fortran types)

	 extern struct _dtype lam_mpi_byte;
	 extern struct _dtype lam_mpi_packed;
	 extern struct _dtype lam_mpi_char;
	 extern struct _dtype lam_mpi_short;
	 extern struct _dtype lam_mpi_int;
	 extern struct _dtype lam_mpi_long;
	 extern struct _dtype lam_mpi_float;
	 extern struct _dtype lam_mpi_double;
	 extern struct _dtype lam_mpi_long_double;
	 extern struct _dtype lam_mpi_unsigned_char;
	 extern struct _dtype lam_mpi_signed_char;
	 extern struct _dtype lam_mpi_unsigned_short;
	 extern struct _dtype lam_mpi_unsigned_long;
	 extern struct _dtype lam_mpi_unsigned;
	 extern struct _dtype lam_mpi_float_int;
	 extern struct _dtype lam_mpi_double_int;
	 extern struct _dtype lam_mpi_longdbl_int;
	 extern struct _dtype lam_mpi_long_int;
	 extern struct _dtype lam_mpi_short_int;
	 extern struct _dtype lam_mpi_2int;
	 extern struct _dtype lam_mpi_ub;
	 extern struct _dtype lam_mpi_lb;
	 extern struct _dtype lam_mpi_wchar;
	 extern struct _dtype lam_mpi_long_long_int;
	 extern struct _dtype lam_mpi_unsigned_long_long;
//	 extern struct _dtype lam_mpi_2cplex;
//	 extern struct _dtype lam_mpi_2dblcplex;

	 // note: mpi 2.1 specifies types that have been removed in 2.2

	 // error policies

	 extern struct ompi_errhandler_t ompi_mpi_errors_are_fatal;
	 extern struct ompi_errhandler_t ompi_mpi_errors_return;
	
   ]]

   -- null handlers

   m.MPI_GROUP_NULL = ffi.new("MPI_Group",0)
   m.MPI_COMM_NULL = ffi.new("MPI_Comm",0)
   m.MPI_REQUEST_NULL = ffi.new("MPI_Request",0)
   m.MPI_OP_NULL = ffi.new("MPI_Op",0)
   m.MPI_ERRHANDLER_NULL = ffi.new("MPI_Errhandler",0)
   m.MPI_INFO_NULL = ffi.new("MPI_Info",0)
   m.MPI_WIN_NULL = ffi.new("MPI_Win",0)
   m.MPI_FILE_NULL = ffi.new("MPI_File",0)
   m.MPI_DATATYPE_NULL = ffi.new("MPI_Datatype",0)

   m.MPI_STATUS_IGNORE = ffi.cast("MPI_Status*",0)
   MPI_STATUSES_IGNORE = ffi.cast("MPI_Status*",0)
   m.MPI_ERRCODES_IGNORE=      ffi.cast("int *", 0)

   -- communicators

   m.MPI_COMM_WORLD = l.lam_mpi_comm_world
   m.MPI_COMM_SELF = l.lam_mpi_comm_self

   -- groups

   m.MPI_GROUP_EMPTY = l.lam_mpi_group_empty

   -- operators

   m.MPI_MAX = l.lam_mpi_max
   m.MPI_MIN = l.lam_mpi_min
   m.MPI_SUM = l.lam_mpi_sum
   m.MPI_PROD = l.lam_mpi_prod
   m.MPI_LAND = l.lam_mpi_land
   m.MPI_BAND = l.lam_mpi_band
   m.MPI_LOR = l.lam_mpi_lor
   m.MPI_BOR = l.lam_mpi_bor
   m.MPI_LXOR = l.lam_mpi_lxor
   m.MPI_BXOR = l.lam_mpi_bxor
   m.MPI_MAXLOC = l.lam_mpi_maxloc
   m.MPI_MINLOC = l.lam_mpi_minloc
   m.MPI_REPLACE = l.lam_mpi_replace

   -- datatypes
   
   m.MPI_BYTE = l.lam_mpi_byte
   m.MPI_PACKED = l.lam_mpi_packed
   m.MPI_CHAR = l.lam_mpi_char
   m.MPI_SHORT = l.lam_mpi_short
   m.MPI_INT = l.lam_mpi_int
   m.MPI_LONG = l.lam_mpi_long
   m.MPI_FLOAT = l.lam_mpi_float
   m.MPI_DOUBLE = l.lam_mpi_double
   m.MPI_LONG_DOUBLE = l.lam_mpi_long_double
   m.MPI_UNSIGNED_CHAR = l.lam_mpi_unsigned_char
   m.MPI_SIGNED_CHAR = l.lam_mpi_signed_char
   m.MPI_UNSIGNED_SHORT = l.lam_mpi_unsigned_short
   m.MPI_UNSIGNED_LONG = l.lam_mpi_unsigned_long
   m.MPI_UNSIGNED = l.lam_mpi_unsigned
   m.MPI_FLOAT_INT = l.lam_mpi_float_int
   m.MPI_DOUBLE_INT = l.lam_mpi_double_int
   m.MPI_LONG_DOUBLE_INT = l.lam_mpi_longdbl_int
   m.MPI_LONG_INT = l.lam_mpi_long_int
   m.MPI_SHORT_INT = l.lam_mpi_short_int
   m.MPI_2INT = l.lam_mpi_2int
   m.MPI_UB = l.lam_mpi_ub
   m.MPI_LB = l.lam_mpi_lb
   m.MPI_WCHAR = l.lam_mpi_wchar
   m.MPI_LONG_LONG_INT = l.lam_mpi_long_long_int
   m.MPI_LONG_LONG = l.lam_mpi_long_long_int
   m.MPI_UNSIGNED_LONG_LONG = l.lam_mpi_unsigned_long_long

   -- note: we do not interface Fortran datatypes.   

--   m.MPI_TYPECLASS_INTEGER = 1   lam does not define typeclass
--   m.MPI_TYPECLASS_REAL = 2
--   m.MPI_TYPECLASS_COMPLEX = 3

   -- error policy

   m.MPI_ERRORS_ARE_FATAL = l.lam_mpi_errors_are_fatal
   m.MPI_ERRORS_RETURN = l.lam_mpi_errors_return

   -- error table

   m.errtab = {}
   local errtab = m.errtab
   m.MPI_ERR_BUFFER= 1
   m.MPI_ERR_COUNT= 2
   m.MPI_ERR_TYPE= 3
   m.MPI_ERR_TAG= 4
   m.MPI_ERR_COMM= 5
   m.MPI_ERR_RANK= 6
   m.MPI_ERR_REQUEST= 7
   m.MPI_ERR_ROOT= 8
   m.MPI_ERR_GROUP= 9
   m.MPI_ERR_OP= 10
   m.MPI_ERR_TOPOLOGY= 11
   m.MPI_ERR_DIMS= 12
   m.MPI_ERR_ARG= 13
   m.MPI_ERR_UNKNOWN= 14
   m.MPI_ERR_TRUNCATE= 15
   m.MPI_ERR_OTHER= 16
   m.MPI_ERR_INTERN= 17
   m.MPI_ERR_IN_STATUS=	18
   m.MPI_ERR_PENDING= 19
   m.MPI_ERR_SYSRESOURCE= 20
   m.MPI_ERR_LOCALDEAD=	21
   m.MPI_ERR_REMOTEDEAD= 22
   m.MPI_ERR_VALUE= 23
   m.MPI_ERR_FLAGS= 24
   m.MPI_ERR_SERVICE= 25
   m.MPI_ERR_NAME= 26
   m.MPI_ERR_SPAWN= 27
   m.MPI_ERR_KEYVAL= 28
   m.MPI_ERR_INFO_NOKEY= 29
   m.MPI_ERR_WIN= 30
   m.MPI_ERR_EPOCH= 31
   m.MPI_ERR_TYPENOTSUP= 32
   m.MPI_ERR_INFO_KEY= 33
   m.MPI_ERR_INFO_VALUE= 34
   m.MPI_ERR_NO_MEM= 35
   m.MPI_ERR_BASE= 36
   m.MPI_ERR_LASTCODE= 37

   -- misc constants

   local OPAL_MAX_DATAREP_STRING= 128
   local OPAL_MAX_ERROR_STRING= 256
   local OPAL_MAX_INFO_KEY= 36
   local OPAL_MAX_INFO_VAL= 256
   local OPAL_MAX_OBJECT_NAME= 64
   local OPAL_MAX_PORT_NAME= 36
   local OPAL_MAX_PROCESSOR_NAME= 256

   m.MPI_ANY_SOURCE=         -1
   m.MPI_PROC_NULL=          -2
   m.MPI_ROOT=               -4
   m.MPI_ANY_TAG=            -1

   m.MPI_MAX_PROCESSOR_NAME= OPAL_MAX_PROCESSOR_NAME
   m.MPI_MAX_ERROR_STRING=   OPAL_MAX_ERROR_STRING
   m.MPI_MAX_OBJECT_NAME=    OPAL_MAX_OBJECT_NAME
   m.MPI_MAX_PORT_NAME=        OPAL_MAX_PORT_NAME
--   m.MPI_MAX_NAME_LEN=         MPI_MAX_PORT_NAME  not part of standard.

   m.MPI_UNDEFINED=          -32766
   m.MPI_KEYVAL_INVALID=     -1

   m.MPI_BSEND_OVERHEAD=       40

   m.MPI_BOTTOM= ffi.cast("void *",0) 

   m.MPI_MAX_INFO_KEY=         36
   m.MPI_MAX_INFO_VAL=         256

   m.MPI_ARGV_NULL=            ffi.cast("char**",0)
   m.MPI_ARGVS_NULL=           ffi.cast("char ***", 0)

   m.MPI_ORDER_C=              0
   m.MPI_ORDER_FORTRAN=        1
   m.MPI_DISTRIBUTE_BLOCK=     0
   m.MPI_DISTRIBUTE_CYCLIC=    1
   m.MPI_DISTRIBUTE_NONE=      2
   m.MPI_DISTRIBUTE_DFLT_DARG= (-1)

   m.MPI_IN_PLACE= ffi.cast("void *",1)

   m.MPI_TAG_UB = 0
   m.MPI_HOST = 1
   m.MPI_IO = 2
   m.MPI_WTIME_IS_GLOBAL = 3
   m.MPI_UNIVERSE_SIZE = 4
   m.MPI_APPNUM = 5
 --  m.MPI_LASTUSEDCODE = 5
   m.MPI_WIN_BASE = 6
   m.MPI_WIN_SIZE = 7
   m.MPI_WIN_DISP_UNIT = 8

--   m.IMPI_CLIENT_SIZE = 9
--   m.IMPI_CLIENT_COLOR = 10
--   m.IMPI_HOST_SIZE = 11
--   m.IMPI_HOST_COLOR = 12

   m.MPI_CART=               1
   m.MPI_GRAPH=              2

   m.MPI_IDENT = 1
   m.MPI_CONGRUENT= 2
   m.MPI_SIMILAR = 3
   m.MPI_UNEQUAL = 4

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
