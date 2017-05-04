import { fork } from "redux-saga/effects";
import { itemSagas } from "./modules/Item";
import { orderSagas } from "./modules/Order";

// main saga generators
export function* sagas() {
  yield [
    fork(itemSagas),
    fork(orderSagas),
  ]
}
