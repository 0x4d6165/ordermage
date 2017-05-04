import React, { Component, PropTypes } from "react";

// Home page component
export default class Item extends Component {
  // render
  render() {
    console.log("Today's item is:"+this.props.item);
    return (
      <div className="item">
        <p>Id: {this.props.item._itemId}</p>
        <p>ItemName: {this.props.item._itemName}</p>
        <p>ItemDescription: {this.props.item._itemDesc}</p>
        <p>ItemVendor: {this.props.item._itemVendor}</p>
        <button onClick={this.props.handleClick}>Add to cart</button>
      </div>
    );
  }
}

Item.propTypes = {
  item: PropTypes.object.isRequired,
  handleClick: PropTypes.func.isRequired,
}
