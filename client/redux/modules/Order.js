import { takeLatest, call, put, fork } from 'redux-saga/effects';
import { clearCart } from "./Cart";

//const ADD_ORDER         = "ordermage/order/ADD_ORDER";
const ADD_ORDER_REQUEST = "ordermage/order/ADD_ORDER_REQUEST";
const ADD_ORDERS        = "ordermage/order/ADD_ORDERS";
const FETCH_ORDERS      = "ordermage/order/FETCH_ORDERS";

const initialState = []
export default function reducer(state=initialState, action) {
  switch (action.type) {
    //case ADD_ORDER:
      //return [...state, action.payload];

    case ADD_ORDERS:
      return action.payload;

    default:
      return state;
  }
}

//export function addOrder(order) {
  //return {
    //type: ADD_ORDER,
    //payload: order
  //}
//}

export function addOrderRequest(order) {
  return {
    type: ADD_ORDER_REQUEST,
    order
  }
}


export function addOrders(orders) {
  return {
    type: ADD_ORDERS,
    payload: orders
  }
}

export function fetchOrders() {
  return {
    type: FETCH_ORDERS
  }
}

const baseURL = "http://localhost:3000"

function callApi(url, requestObj = {}) {
  return fetch(url, requestObj)
    .then(res => res.json())
    .then(response => response)
    .catch(err => console.log(err));
}

function *fetchOrdersSaga() {
  //const orders = yield call(callApi, `${baseURL}/order`, { mode: 'no-cors' });
  const orders = yield call(callApi, `${baseURL}/order`);
  //yield call(console.log, orders)
  yield put(addOrders(orders));
}

function *addOrderRequestSaga(newOrder) {
  const order = newOrder.order;
  yield call(callApi, `${baseURL}/order`, {
    method: 'POST',
    body: JSON.stringify({
      _orderItems: order,
    }),
    headers: new Headers({
      'Content-Type': 'application/json',
    }),
  });
  //yield put(addPost(newOrder));
  yield put(clearCart());
}

export function* orderSagas() {
  yield [
    fork(takeLatest, FETCH_ORDERS, fetchOrdersSaga),
    fork(takeLatest, ADD_ORDER_REQUEST, addOrderRequestSaga),
  ];
}
