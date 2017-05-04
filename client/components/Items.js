import React, { Component } from "react";
import { connect } from "react-redux";
import Item from "./Item"
import ItemCreate from "./ItemCreate"
import { fetchItems, addItemRequest } from '../redux/modules/Item';
import { addItem } from '../redux/modules/Cart';

export class Items extends Component {
  constructor(props, context) {
    super(props, context);
    this.add = this.add.bind(this);
  }

  add(name, desc, vendor) {
    this.props.dispatch(addItemRequest({ name, desc, vendor }));
  }

  componentDidMount() {
    console.log('Fetching items..');
    this.props.dispatch(fetchItems());
  }

  handleClick(item) {
    console.log(item);
    this.props.dispatch(addItem(item._itemId));
  }

  // render
  render() {
    if (!this.props.items) {
      //this.props.dispatch(fetchItems());
      return (
        <div>
          <h4>Items:</h4>
          <p>No items loaded.</p>
          <ItemCreate addItem={this.add}/>
        </div>
      )
    } else {
      console.log(this.props.items);
    }
    return (
      <div className="page-home">
        <h4>Items:</h4>
        <div>
          {
            this.props.items.map((item) => (
              //console.log(item);
              <Item item={item} handleClick={this.handleClick.bind(this, item)} />
            ))
          }
          <ItemCreate addItem={this.add}/>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    items: state.item
  };
}

export default connect(mapStateToProps)(Items);
        //{
          //this.props.items.map((item) => {
            //console.log(item);
            //<Item item={item} />
          //})
        //}
        //<ItemCreate addItem={this.add}/>
