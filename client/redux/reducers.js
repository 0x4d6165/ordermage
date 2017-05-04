import { combineReducers } from "redux";
import { routerReducer } from "react-router-redux";
import itemReducer from "./modules/Item"
import orderReducer from "./modules/Order";
import cartReducer from "./modules/Cart";

// main reducers
export const reducers = combineReducers({
  routing: routerReducer,
  item: itemReducer,
  order: orderReducer,
  cart: cartReducer,
});
