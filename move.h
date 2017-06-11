#ifndef MOVE_H
#define MOVE_H

#include "types.h"

void update_estimators(const PKT *restrict pkt_ptr, double distance);
void move_pkt(PKT *restrict pkt_ptr, double distance, double time);

#endif //MOVE_H
