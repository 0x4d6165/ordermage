import React from "react";

// Home page component
export default class Order extends React.Component {
  // render
  render() {
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
