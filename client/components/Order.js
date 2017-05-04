import React, { Component, PropTypes } from "react";

// Home page component
export default class Order extends Component {
  // render
  render() {
    console.log("Today's order is:"+this.props.order);
    return (
      <div className="order">
        <p>Id: {this.props.order._orderId}</p>
        <p>ItemIds: {this.props.order._orderItems}</p>
        <p>OrderDate: {this.props.order._orderDate}</p>
      </div>
    );
  }
}

Order.propTypes = {
  order: PropTypes.object.isRequired,
}
