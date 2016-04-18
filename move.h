#ifndef MOVE_H
#define MOVE_H

#include "types.h"

void update_estimators(const PKT *pkt_ptr, double distance);
int move_pkt(PKT *pkt_ptr, double distance, double time);

#endif //MOVE_H
