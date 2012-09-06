local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.math.blas",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------

local _assert, _error = assert, error
local _pcall = pcall
local _upper = string.upper
local _concat = table.concat
local _print = print
local _type = type

-------------------------------------------------------------------------------
--- <p><b>Module:</b> BLAS interface. </p>
--
module( _H.FILE )
-------------------------------------------------------------------------------


libname = nil
lib = nil
f77name = nil

local known_blas_libnames = {
-- "goto2",
   "blas",
   nil
}


-- taken from R's BLAS interface
local blas_cdefs = [[
double F77(dasum)(const int *n, const double *dx, const int *incx);
void   F77(daxpy)(const int *n, const double *alpha,
		       const double *dx, const int *incx,
		       double *dy, const int *incy);
void   F77(dcopy)(const int *n, const double *dx, const int *incx,
		       double *dy, const int *incy);
double F77(ddot) (const int *n, const double *dx, const int *incx,
		       const double *dy, const int *incy);
double F77(dnrm2)(const int *n, const double *dx, const int *incx);
void   F77(drot) (const int *n, double *dx, const int *incx,
		       double *dy, const int *incy, const double *c,
		       const double *s);
void   F77(drotg)(const double *a, const double *b, double *c, 
		       double *s);
void   F77(drotm)(const int *n, double *dx, const int *incx,
		       double *dy, const int *incy,const double *dparam);
void   F77(drotmg)(const double *dd1, const double *dd2, 
			const double *dx1, const double *dy1, 
			double *param);
void   F77(dscal)(const int *n, const double *alpha, double *dx,
		       const int *incx);
void   F77(dswap)(const int *n, double *dx, const int *incx,
		       double *dy, const int *incy);
int    F77(idamax)(const int *n, const double *dx, const int *incx);
void   F77(dgbmv)(const char *trans, const int *m, const int *n,
		       const int *kl,const int *ku, const double *alpha,
		       const double *a, const int *lda, const double *x,
		       const int *incx, const double *beta, double *y,
		       const int *incy);
void   F77(dgemv)(const char *trans, const int *m, const int *n,
		       const double *alpha, const double *a,
		       const int *lda, const double *x, const int *incx,
		       const double *beta, double *y, const int *incy);
void   F77(dsbmv)(const char *uplo, const int *n, const int *k,
		       const double *alpha, const double *a,
		       const int *lda, const double *x, const int *incx,
		       const double *beta, double *y, const int *incy);
void   F77(dspmv)(const char *uplo, const int *n,
		       const double *alpha, const double *ap,
		       const double *x, const int *incx,
		       const double *beta, double *y, const int *incy);
void   F77(dsymv)(const char *uplo, const int *n,
		       const double *alpha, const double *a,
		       const int *lda, const double *x, const int *incx,
		       const double *beta, double *y, const int *incy);
void   F77(dtbmv)(const char *uplo, const char *trans,
		       const char *diag, const int *n, const int *k,
		       const double *a, const int *lda,
		       double *x, const int *incx);
void   F77(dtpmv)(const char *uplo, const char *trans,
		       const char *diag, const int *n, const double *ap,
		       double *x, const int *incx);
void   F77(dtrmv)(const char *uplo, const char *trans,
		       const char *diag, const int *n, const double *a,
		       const int *lda, double *x, const int *incx);
void   F77(dtbsv)(const char *uplo, const char *trans,
		       const char *diag, const int *n, const int *k,
		       const double *a, const int *lda,
		       double *x, const int *incx);
void   F77(dtpsv)(const char *uplo, const char *trans,
		       const char *diag, const int *n,
		       const double *ap, double *x, const int *incx);
void   F77(dtrsv)(const char *uplo, const char *trans,
		       const char *diag, const int *n,
		       const double *a, const int *lda,
		       double *x, const int *incx);
void   F77(dger) (const int *m, const int *n, const double *alpha,
		       double *x, const int *incx,
		       double *y, const int *incy,
		       double *a, const int *lda);
void   F77(dsyr) (const char *uplo, const int *n,
		       const double *alpha, const double *x,
		       const int *incx, double *a, const int *lda);
void   F77(dspr) (const char *uplo, const int *n,
		       const double *alpha, const double *x,
		       const int *incx, double *ap);
void   F77(dsyr2)(const char *uplo, const int *n, 
		       const double *alpha, const double *x,
		       const int *incx, const double *y, const int *incy,
		       double *a, const int *lda);
void   F77(dspr2)(const char *uplo, const int *n,
		       const double *alpha, const double *x,
		       const int *incx, const double *y,
		       const int *incy, double *ap);
void   F77(dgemm)(const char *transa, const char *transb,
		       const int *m, const int *n, const int *k,
		       const double *alpha, const double *a,
		       const int *lda, const double *b, const int *ldb,
		       const double *beta, double *c, const int *ldc);
void   F77(dtrsm)(const char *side, const char *uplo,
		       const char *transa, const char *diag,
		       const int *m, const int *n, const double *alpha,
		       const double *a, const int *lda,
		       double *b, const int *ldb);
void   F77(dtrmm)(const char *side, const char *uplo,
		       const char *transa, const char *diag,
		       const int *m, const int *n, const double *alpha,
		       const double *a, const int *lda,
		       double *b, const int *ldb);
void   F77(dsymm)(const char *side, const char *uplo, const int *m,
		       const int *n, const double *alpha,
		       const double *a, const int *lda,
		       const double *b, const int *ldb,
		       const double *beta, double *c, const int *ldc);
void   F77(dsyrk)(const char *uplo, const char *trans,
		       const int *n, const int *k,
		       const double *alpha, const double *a,
		       const int *lda, const double *beta,
		       double *c, const int *ldc);
void   F77(dsyr2k)(const char *uplo, const char *trans,
			const int *n, const int *k,
			const double *alpha, const double *a,
			const int *lda, const double *b, const int *ldb,
			const double *beta, double *c, const int *ldc);
]]

local function getsym(name)
   return lib[name]
end

-- Test for F77 call convention and return f77 name wrapper
function getf77name(lib, name)
   _assert(lib, "arg1 (lib) undefined")
   _assert(_type(name) == 'string', "arg2 (name) is not a string")
   local name = "dasum"
   local uname = _upper(name)
   local ret = "void "
   local arg = "();\n";
   local str = {
      ret, name, arg,
      ret, name, "_", arg,
      ret, uname, arg,
      ret, uname, "_", arg
   }
   ffi.cdef(_concat(str))
   if _pcall(getsym, name.."_") then
      return function(name) return name.."_" end
   elseif _pcall(getsym, name) then
      return function(name) return name end
   elseif _pcall(getsym, uname) then
      return function(name) return _upper(name) end
   elseif _pcall(getsym,uname.."_") then
      return function(name) return _upper(name).."_" end
   else
      _error("failed to figure out F77 calling convention")
   end
end

local function loadcdefs()
   local cdefs = blas_cdefs:gsub("F77%((%w+)%)", f77name)
   ffi.cdef(cdefs)
end

-- Bind to blas
function bind()
   local ok, l
   for i=1, #known_blas_libnames do
      local k = known_blas_libnames[i]
      ok, l = _pcall( ffi.load, k, true )		   
      if ok then 
	 libname = k
	 lib = l
	 break 
      end
   end
   _assert(ok, "failed to bind to BLAS library") 
   lib = l
   f77name = getf77name(lib,"dasum")
   loadcdefs()
end


-------------------------------------------------------------------------------
