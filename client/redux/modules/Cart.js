import { takeLatest, call, put, fork } from 'redux-saga/effects';

const ADD_ITEM = "ordermage/cart/ADD_ITEM";
const CLEAR_CART = "ordermage/cart/CLEAR_CART";

const initialState = []
export default function reducer(state=initialState, action) {
  switch (action.type) {
    case ADD_ITEM:
      return [...state, action.payload];

    case CLEAR_CART:
      return [];

    default:
      return state;
  }
}

export function addItem(item) {
  return {
    type: ADD_ITEM,
    payload: item
  }
}

export function clearCart() {
  return {
    type: CLEAR_CART,
  }
}
