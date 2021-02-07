#include <Rinternals.h>

SEXP foo_c_code(SEXP x, SEXP y) {
    double xx = REAL(x)[0];
    double yy = REAL(y)[0];
    double result = xx / yy;
    return Rf_ScalarReal(result);
}
