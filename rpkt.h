#ifndef RPKT_H
#define RPKT_H

#include "types.h"

__host__ __device__ double do_rpkt(PKT *pkt_ptr, double t1, double t2, int tid);
__host__ __device__ void emitt_rpkt(PKT *pkt_ptr, double t_current);
__host__ __device__ int closest_transition(double nu_cmf, int next_trans);
double get_rpkt_escape_prob(PKT *pkt_ptr, const double tstart, int tid);
__host__ __device__ void calculate_kappa_bf_fb_gammacontr(const int modelgridindex, const double nu, double *kappa_bf, double *kappa_fb, int tid);
__host__ __device__ void calculate_kappa_rpkt_cont(const PKT *const pkt_ptr, const double t_current, const int modelgridindex, int tid);
void calculate_kappa_vpkt_cont(const PKT *pkt_ptr, double t_current, int tid);

#endif //RPKT_H
