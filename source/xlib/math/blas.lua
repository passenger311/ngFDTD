local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.math.blas",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local ffi = xlib.ffi
local string = xlib.string
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


flavor = nil
lib = nil

local known_blas_libnames = {
-- "goto2",
   "blas",
   nil
}

-- taken from R's BLAS interface; these are plain names which we will
-- decorate according to the Fortran symbol naming convention. 

local blas_extern_cdefs = [[

double dasum(const int *n, const double *dx, const int *incx);
void   daxpy(const int *n, const double *alpha,
	     const double *dx, const int *incx,
	     double *dy, const int *incy);
void   dcopy(const int *n, const double *dx, const int *incx,
	     double *dy, const int *incy);
double ddot(const int *n, const double *dx, const int *incx,
	    const double *dy, const int *incy);
double dnrm2(const int *n, const double *dx, const int *incx);
void   drot(const int *n, double *dx, const int *incx,
	    double *dy, const int *incy, const double *c,
	    const double *s);
void   drotg(const double *a, const double *b, double *c, 
	     double *s);
void   drotm(const int *n, double *dx, const int *incx,
	     double *dy, const int *incy,const double *dparam);
void   drotmg(const double *dd1, const double *dd2, 
	      const double *dx1, const double *dy1, 
	      double *param);
void   dscal(const int *n, const double *alpha, double *dx,
	     const int *incx);
void   dswap(const int *n, double *dx, const int *incx,
	     double *dy, const int *incy);
int    idamax(const int *n, const double *dx, const int *incx);
void   dgbmv(const char *trans, const int *m, const int *n,
	     const int *kl,const int *ku, const double *alpha,
	     const double *a, const int *lda, const double *x,
	     const int *incx, const double *beta, double *y,
	     const int *incy);
void   dgemv(const char *trans, const int *m, const int *n,
	     const double *alpha, const double *a,
	     const int *lda, const double *x, const int *incx,
	     const double *beta, double *y, const int *incy);
void   dsbmv(const char *uplo, const int *n, const int *k,
	     const double *alpha, const double *a,
	     const int *lda, const double *x, const int *incx,
	     const double *beta, double *y, const int *incy);
void   dspmv(const char *uplo, const int *n,
	     const double *alpha, const double *ap,
	     const double *x, const int *incx,
	     const double *beta, double *y, const int *incy);
void   dsymv(const char *uplo, const int *n,
	     const double *alpha, const double *a,
	     const int *lda, const double *x, const int *incx,
	     const double *beta, double *y, const int *incy);
void   dtbmv(const char *uplo, const char *trans,
	     const char *diag, const int *n, const int *k,
	     const double *a, const int *lda,
	     double *x, const int *incx);
void   dtpmv(const char *uplo, const char *trans,
	     const char *diag, const int *n, const double *ap,
	     double *x, const int *incx);
void   dtrmv(const char *uplo, const char *trans,
	     const char *diag, const int *n, const double *a,
	     const int *lda, double *x, const int *incx);
void   dtbsv(const char *uplo, const char *trans,
	     const char *diag, const int *n, const int *k,
	     const double *a, const int *lda,
	     double *x, const int *incx);
void   dtpsv(const char *uplo, const char *trans,
	     const char *diag, const int *n,
	     const double *ap, double *x, const int *incx);
void   dtrsv(const char *uplo, const char *trans,
	     const char *diag, const int *n,
	     const double *a, const int *lda,
	     double *x, const int *incx);
void   dger(const int *m, const int *n, const double *alpha,
	    double *x, const int *incx,
	    double *y, const int *incy,
	    double *a, const int *lda);
void   dsyr(const char *uplo, const int *n,
	    const double *alpha, const double *x,
	    const int *incx, double *a, const int *lda);
void   dspr(const char *uplo, const int *n,
	    const double *alpha, const double *x,
	    const int *incx, double *ap);
void   dsyr2(const char *uplo, const int *n, 
	     const double *alpha, const double *x,
	     const int *incx, const double *y, const int *incy,
	     double *a, const int *lda);
void   dspr2(const char *uplo, const int *n,
	     const double *alpha, const double *x,
	     const int *incx, const double *y,
	     const int *incy, double *ap);
void   dgemm(const char *transa, const char *transb,
	     const int *m, const int *n, const int *k,
	     const double *alpha, const double *a,
	     const int *lda, const double *b, const int *ldb,
	     const double *beta, double *c, const int *ldc);
void   dtrsm(const char *side, const char *uplo,
	     const char *transa, const char *diag,
	     const int *m, const int *n, const double *alpha,
	     const double *a, const int *lda,
	     double *b, const int *ldb);
void   dtrmm(const char *side, const char *uplo,
	     const char *transa, const char *diag,
	     const int *m, const int *n, const double *alpha,
	     const double *a, const int *lda,
	     double *b, const int *ldb);
void   dsymm(const char *side, const char *uplo, const int *m,
	     const int *n, const double *alpha,
	     const double *a, const int *lda,
	     const double *b, const int *ldb,
	     const double *beta, double *c, const int *ldc);
void   dsyrk(const char *uplo, const char *trans,
	     const int *n, const int *k,
	     const double *alpha, const double *a,
	     const int *lda, const double *beta,
	     double *c, const int *ldc);
void   dsyr2k(const char *uplo, const char *trans,
	      const int *n, const int *k,
	      const double *alpha, const double *a,
	      const int *lda, const double *b, const int *ldb,
	      const double *beta, double *c, const int *ldc);
]]

-- Bind to blas
function bind(names)
  names = names or known_blas_libnames
  local ok, l
   for i=1, #names do
      local k = names[i]
      ok, l = _pcall( ffi.load, k, true )		   
      if ok then 
	 flavor = k
	 lib = l
	 break 
      end
   end
   _assert(ok, "failed to bind to BLAS library") 
   lib = l
   ffi.wrapf77defs( lib, blas_extern_cdefs )
   return lib
end


-------------------------------------------------------------------------------
