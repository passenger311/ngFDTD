local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms.mpi.mpich2",
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
--- <p><b>Module:</b> MPICH2 declarations. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------


-- get rank and size
function detect(m)
   -- check environment
   local v1 = _getenv("HYDRA_CONTROL_FD")
   local v2 = _getenv("MPICH_INTERFACE_HOSTNAME")
   m.rank = _getenv("PMI_RANK")
   m.size = _getenv("PMI_SIZE")
   return v1 and v2 and m.size and m.rank
end

-- inject definitions
function inject(m)

   -- bind to MPI library

   local ok, l = _pcall( ffi.load, "mpich", true )		   
   _assert(ok, "ffi failed to bind to MPI (mpich) library") 
   m.lib = l

   -- declarations

   ffi.cdef[[

	 typedef struct ompi_status_public_t {
	    /* internal */
	    int cancelled;
	    size_t count;
	    /* public */
	    int MPI_SOURCE;
	    int MPI_TAG;
	    int MPI_ERROR;
	 } MPI_Status;

	 // types: mpich2 uses mostly integers

	 typedef int MPI_Datatype;
	 typedef int MPI_Comm; 
	 typedef long MPI_Aint;
	 typedef long long MPI_Offset;
	 typedef long MPI_Fint;
	 typedef int MPI_Errhandler;
	 typedef struct ADIOI_FileD *MPI_File;
	 typedef int MPI_Group;
	 typedef int *MPI_Info;
	 typedef int *MPI_Op;
	 typedef int MPI_Request;
	 typedef int MPI_Win;

	 // there are a few externals which might be used to id mpich library	
	 extern int MPICH_ATTR_FAILED_PROCESSES;
	 extern MPI_Fint* MPI_F_STATUS_IGNORE;
	 extern MPI_Fint* MPI_F_STATUSES_IGNORE;
   ]]

   -- null handlers
   m.MPI_COMM_NULL       = 0x04000000
   m.MPI_OP_NULL         = 0x18000000
   m.MPI_GROUP_NULL      = 0x08000000
   m.MPI_DATATYPE_NULL   = 0x0c000000
   m.MPI_REQUEST_NULL    = 0x2c000000
   m.MPI_ERRHANDLER_NULL = 0x14000000
   m.MPI_INFO_NULL = 0x1c000000
   m.MPI_WIN_NULL = 0x20000000
   m.MPI_FILE_NULL = ffi.cast("MPI_File",0)

   m.MPI_STATUSES_IGNORE = ffi.cast("MPI_Status*",1)
   m.MPI_STATUS_IGNORE = ffi.cast("MPI_Status*",1)
   m.MPI_ERRCODES_IGNORE = ffi.cast("int*",1)

   -- communicators

   m.MPI_COMM_WORLD = 0x44000000
   m.MPI_COMM_SELF = 0x44000001

   -- groups

   m.MPI_GROUP_EMPTY = 0x48000000

   -- operators

   m.MPI_MAX     = 0x58000001
   m.MPI_MIN     = 0x58000002
   m.MPI_SUM     = 0x58000003
   m.MPI_PROD    = 0x58000004
   m.MPI_LAND    = 0x58000005
   m.MPI_BAND    = 0x58000006
   m.MPI_LOR     = 0x58000007
   m.MPI_BOR     = 0x58000008
   m.MPI_LXOR    = 0x58000009
   m.MPI_BXOR    = 0x5800000a
   m.MPI_MINLOC  = 0x5800000b
   m.MPI_MAXLOC  = 0x5800000c
   m.MPI_REPLACE = 0x5800000d

   -- datatypes
   
   m.MPI_CHAR           = 0x4c000101
   m.MPI_SIGNED_CHAR    = 0x4c000118
   m.MPI_UNSIGNED_CHAR  = 0x4c000102
   m.MPI_BYTE           = 0x4c00010d
   m.MPI_WCHAR          = 0x4c00040e
   m.MPI_SHORT          = 0x4c000203
   m.MPI_UNSIGNED_SHORT = 0x4c000204
   m.MPI_INT            = 0x4c000405
   m.MPI_UNSIGNED       = 0x4c000406
   m.MPI_LONG           = 0x4c000807
   m.MPI_UNSIGNED_LONG  = 0x4c000808
   m.MPI_FLOAT          = 0x4c00040a
   m.MPI_DOUBLE         = 0x4c00080b
   m.MPI_LONG_DOUBLE    = 0x4c00100c
   m.MPI_LONG_LONG_INT  = 0x4c000809
   m.MPI_UNSIGNED_LONG_LONG = 0x4c000819
   m.MPI_LONG_LONG      MPI_LONG_LONG_INT
   m.MPI_PACKED         = 0x4c00010f
   m.MPI_LB             = 0x4c000010
   m.MPI_UB             = 0x4c000011
   m.MPI_FLOAT_INT         = 0x8c000000
   m.MPI_DOUBLE_INT        = 0x8c000001
   m.MPI_LONG_INT          = 0x8c000002
   m.MPI_SHORT_INT         = 0x8c000003
   m.MPI_2INT              = 0x4c000816
   m.MPI_LONG_DOUBLE_INT   = 0x8c000004

   -- note: we do not interface Fortran datatypes.   

   m.MPI_TYPECLASS_REAL = 1
   m.MPI_TYPECLASS_INTEGER = 2
   m.MPI_TYPECLASS_COMPLEX = 3

   -- error policy

   m.MPI_ERRORS_ARE_FATAL = 0x54000000
   m.MPI_ERRORS_RETURN = 0x54000001

   -- error table

   m.errtab = {}
   local errtab = m.errtab

   errtab.MPI_SUCCESS         = 0
   errtab.MPI_ERR_BUFFER      = 1
   errtab.MPI_ERR_COUNT       = 2
   errtab.MPI_ERR_TYPE        = 3
   errtab.MPI_ERR_TAG         = 4
   errtab.MPI_ERR_COMM        = 5
   errtab.MPI_ERR_RANK        = 6
   errtab.MPI_ERR_ROOT        = 7
   errtab.MPI_ERR_TRUNCATE    =14
   errtab.MPI_ERR_GROUP       = 8
   errtab.MPI_ERR_OP          = 9
   errtab.MPI_ERR_REQUEST     =19
   errtab.MPI_ERR_TOPOLOGY    =10
   errtab.MPI_ERR_DIMS        =11
   errtab.MPI_ERR_ARG         =12
   errtab.MPI_ERR_OTHER       =15
   errtab.MPI_ERR_UNKNOWN     =13
   errtab.MPI_ERR_INTERN      =16
   errtab.MPI_ERR_IN_STATUS   =17
   errtab.MPI_ERR_PENDING     =18
   errtab.MPI_ERR_FILE        =27
   errtab.MPI_ERR_ACCESS      =20
   errtab.MPI_ERR_AMODE       =21
   errtab.MPI_ERR_BAD_FILE    =22
   errtab.MPI_ERR_FILE_EXISTS =25
   errtab.MPI_ERR_FILE_IN_USE =26
   errtab.MPI_ERR_NO_SPACE    =36
   errtab.MPI_ERR_NO_SUCH_FILE =37
   errtab.MPI_ERR_IO          =32 
   errtab.MPI_ERR_READ_ONLY   =40
   errtab.MPI_ERR_CONVERSION  =23
   errtab.MPI_ERR_DUP_DATAREP =24
   errtab.MPI_ERR_UNSUPPORTED_DATAREP   =43
   errtab.MPI_ERR_INFO        =28
   errtab.MPI_ERR_INFO_KEY    =29
   errtab.MPI_ERR_INFO_VALUE  =30
   errtab.MPI_ERR_INFO_NOKEY  =31
   errtab.MPI_ERR_NAME        =33
   errtab.MPI_ERR_NO_MEM      =34
   errtab.MPI_ERR_NOT_SAME    =35
   errtab.MPI_ERR_PORT        =38
   errtab.MPI_ERR_QUOTA       =39
   errtab.MPI_ERR_SERVICE     =41
   errtab.MPI_ERR_SPAWN       =42
   errtab.MPI_ERR_UNSUPPORTED_OPERATION =44
   errtab.MPI_ERR_WIN         =45
   errtab.MPI_ERR_BASE        =46
   errtab.MPI_ERR_LOCKTYPE    =47
   errtab.MPI_ERR_KEYVAL      =48
   errtab.MPI_ERR_RMA_CONFLICT =49
   errtab.MPI_ERR_RMA_SYNC    =50
   errtab.MPI_ERR_SIZE        =51
   errtab.MPI_ERR_DISP        =52
   errtab.MPI_ERR_ASSERT      =53
   errtab.MPI_ERR_LASTCODE    =0x3fffffff
   errtab.MPICH_ERR_LAST_CLASS =53 

   -- misc constants

   m.MPI_PROC_NULL=          -1
   m.MPI_ANY_SOURCE=         -2
   m.MPI_ROOT=               -3
   m.MPI_ANY_TAG=            -1

   m.MPI_MAX_PROCESSOR_NAME= 128
   m.MPI_MAX_ERROR_STRING=   1024
   m.MPI_MAX_PORT_NAME=        256
   m.MPI_MAX_OBJECT_NAME=    128

   m.MPI_UNDEFINED=          -32766
   m.MPI_KEYVAL_INVALID=     0x24000000
   
   m.MPI_BSEND_OVERHEAD=       88

   m.MPI_BOTTOM= ffi.cast("void *",0) 
   --   m.MPI_UNWEIGHTED= ffi.cast("int *",0) -- part of standard? (not defined in openmpi)

   m.MPI_MAX_INFO_KEY=         255
   m.MPI_MAX_INFO_VAL=         1024

   m.MPI_ARGV_NULL=            ffi.cast("char**",0)
   m.MPI_ARGVS_NULL=           ffi.cast("char ***", 0)
--   m.MPI_MAX_NAME_LEN  part of standard?

   m.MPI_ORDER_C=              56
   m.MPI_ORDER_FORTRAN=        57
   m.MPI_DISTRIBUTE_BLOCK=     121
   m.MPI_DISTRIBUTE_CYCLIC=    122
   m.MPI_DISTRIBUTE_NONE=      123
   m.MPI_DISTRIBUTE_DFLT_DARG= (-49767)

   m.MPI_IN_PLACE= ffi.cast("void *",-1)
   
   m.MPI_MODE_NOCHECK           =  1024
   m.MPI_MODE_NOSTORE           =  2048
   m.MPI_MODE_NOPUT             =  4096
   m.MPI_MODE_NOPRECEDE         =  8192
   m.MPI_MODE_NOSUCCEED         = 16384
   
   m.MPI_LOCK_EXCLUSIVE         =  234
   m.MPI_LOCK_SHARED            =  235
   
   m.MPI_TAG_UB = 064400001
   m.MPI_HOST = 0x64400003
   m.MPI_IO = 0x64400005
   m.MPI_WTIME_IS_GLOBAL = 0x64400007
   m.MPI_UNIVERSE_SIZE = 0x64400009
   m.MPI_LASTUSEDCODE = 0x6440000b
   m.MPI_APPNUM = 0x6440000d
   
   m.MPI_WIN_BASE = 0x66000001
   m.MPI_WIN_SIZE = 0x66000003
   m.MPI_WIN_DISP_UNIT = 0x66000005

   m.MPI_GRAPH=              1
   m.MPI_CART=               2
--   m.MPI_DIST_GRAPH          3 -- part of standard? (not defined in openmpi)

   m.MPI_IDENT = 0
   m.MPI_CONGRUENT= 1
   m.MPI_SIMILAR = 2
   m.MPI_UNEQUAL = 3

   m.MPI_THREAD_SINGLE = 0
   m.MPI_THREAD_FUNNELED = 1
   m.MPI_THREAD_SERIALIZED = 2
   m.MPI_THREAD_MULTIPLE = 3

   m.MPI_COMBINER_NAMED = 1
   m.MPI_COMBINER_DUP = 2
   m.MPI_COMBINER_CONTIGUOUS = 3
   m.MPI_COMBINER_VECTOR = 4
   m.MPI_COMBINER_HVECTOR_INTEGER = 5
   m.MPI_COMBINER_HVECTOR = 6
   m.MPI_COMBINER_INDEXED = 7
   m.MPI_COMBINER_HINDEXED_INTEGER = 8
   m.MPI_COMBINER_HINDEXED = 9
   m.MPI_COMBINER_INDEXED_BLOCK = 10
   m.MPI_COMBINER_STRUCT_INTEGER = 11
   m.MPI_COMBINER_STRUCT = 12
   m.MPI_COMBINER_SUBARRAY = 13
   m.MPI_COMBINER_DARRAY = 14
   m.MPI_COMBINER_F90_REAL = 15
   m.MPI_COMBINER_F90_COMPLEX = 16
   m.MPI_COMBINER_F90_INTEGER = 17
   m.MPI_COMBINER_RESIZED = 18

end

------------------------------------------------------------------------------
