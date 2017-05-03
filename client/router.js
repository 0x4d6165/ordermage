import React from "react";
import { Router, Route, IndexRoute } from "react-router";
import { history } from "./store.js";
import App from "./components/App";
import Home from "./components/Home";
import Cart from "./components/Cart";
import Items from "./components/Items";
import Orders from "./components/Orders";
import NotFound from "./components/NotFound";

// build the router
const router = (
  <Router onUpdate={() => window.scrollTo(0, 0)} history={history}>
    <Route path="/" component={App}>
      <IndexRoute component={Home}/>
      <Route path="/cart" component={Cart}/>
      <Route path="/items" component={Items}/>
      <Route path="/orders" components={Orders}/>
      <Route path="*" component={NotFound}/>
    </Route>
  </Router>
);

// export
export { router };
