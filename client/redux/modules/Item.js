import { takeLatest, call, put, fork } from 'redux-saga/effects';

//const ADD_ITEM         = "ordermage/items/ADD_ITEM";
const ADD_ITEM_REQUEST = "ordermage/items/ADD_ITEM_REQUEST";
const ADD_ITEMS        = "ordermage/items/ADD_ITEMS";
const FETCH_ITEMS      = "ordermage/items/FETCH_ITEMS";

const initialState = []
export default function reducer(state=initialState, action) {
  switch (action.type) {
    //case ADD_ITEM:
      //return [...state, action.payload];

    case ADD_ITEMS:
      return action.payload;

    default:
      return state;
  }
}

//export function addItem(item) {
  //return {
    //type: ADD_ITEM,
    //payload: item
  //}
//}

export function addItemRequest(item) {
  return {
    type: ADD_ITEM_REQUEST,
    item
  }
}


export function addItems(items) {
  return {
    type: ADD_ITEMS,
    payload: items
  }
}

export function fetchItems() {
  return {
    type: FETCH_ITEMS
  }
}

const baseURL = "http://localhost:3000"

function callApi(url, requestObj = {}) {
  return fetch(url, requestObj)
    .then(res => res.json())
    .then(response => response)
    .catch(err => console.log(err));
}

function *fetchItemsSaga() {
  //const items = yield call(callApi, `${baseURL}/item`, { mode: 'no-cors' });
  const items = yield call(callApi, `${baseURL}/item`);
  //yield call(console.log, items)
  yield put(addItems(items));
}

function *addItemRequestSaga(newItem) {
  const item = newItem.item;
  yield call(callApi, `${baseURL}/item`, {
    method: 'POST',
    body: JSON.stringify({
      _itemName: item.name,
      _itemDesc: item.desc,
      _itemVendor: item.vendor,
    }),
    headers: new Headers({
      'Content-Type': 'application/json',
    }),
  });
  //yield put(addPost(newItem));
}

export function* itemSagas() {
  yield [
    fork(takeLatest, FETCH_ITEMS, fetchItemsSaga),
    fork(takeLatest, ADD_ITEM_REQUEST, addItemRequestSaga),
  ];
}
