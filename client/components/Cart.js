import React, { Component } from "react";
import { connect } from "react-redux";
import { addOrderRequest } from '../redux/modules/Order';

export class Cart extends Component {
  constructor(props, context) {
    super(props, context);
    this.add = this.add.bind(this);
  }

  add() {
    this.props.dispatch(addOrderRequest(this.props.cart));
  }
  // render
  render() {
    if (!this.props.cart) {
      //this.props.dispatch(fetchItems());
      return (
        <div>
          <h4>Cart:</h4>
          <p>No items added.</p>
        </div>
      )
    } else {
      console.log(this.props.cart);
    }
    return (
      <div className="page-home">
        <h4>Cart:</h4>
        <div>
          {
            this.props.cart.map((item) => (
              //console.log(item);
              <p>{item}</p>
            ))
          }
          <button onClick={this.add}>Submit</button>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    cart: state.cart
  };
}

export default connect(mapStateToProps)(Cart);
        //{
          //this.props.items.map((item) => {
            //console.log(item);
            //<Item item={item} />
          //})
        //}
        //<ItemCreate addItem={this.add}/>
