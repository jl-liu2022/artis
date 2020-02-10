#ifndef PHOTO_ELECTRIC_H
#define PHOTO_ELECTRIC_H

#include "types.h"

double sig_photo_electric(const PKT *pkt_ptr, double t_current);
double sig_pair_prod(const PKT *pkt_ptr, double t_current);
void pair_prod(PKT *pkt_ptr, double t_current);

#endif //PHOTO_ELECTRIC_H