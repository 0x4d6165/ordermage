import React, { Component } from "react";
import { connect } from "react-redux";
import Order from "./Order"
import { fetchOrders, addOrderRequest } from '../redux/modules/Order';

export class Orders extends Component {
  constructor(props, context) {
    super(props, context);
  }

  componentDidMount() {
    console.log('Fetching orders..');
    this.props.dispatch(fetchOrders());
  }

  // render
  render() {
    if (!this.props.orders) {
      //this.props.dispatch(fetchOrders());
      return (
        <div>
          <h4>Orders:</h4>
          <p>No orders loaded.</p>
        </div>
      )
    } else {
      console.log(this.props.orders);
    }
    return (
      <div className="page-home">
        <h4>Orders:</h4>
        {
          this.props.orders.map((order) => (
            //console.log(order);
            <Order order={order} />
          ))
        }
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    orders: state.order
  };
}

export default connect(mapStateToProps)(Orders);
        //{
          //this.props.orders.map((order) => {
            //console.log(order);
            //<Order order={order} />
          //})
        //}
        //<OrderCreate addOrder={this.add}/>
