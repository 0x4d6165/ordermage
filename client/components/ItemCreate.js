import React, { Component, PropTypes } from "react";

export default class ItemCreate extends Component {
  constructor(props, context) {
    super(props, context);
    this.addItem = this.addItem.bind(this);
  }

  addItem() {
    const inameRef = this.refs.iname;
    const idescRef = this.refs.idesc;
    const ivendorRef = this.refs.ivendor;
    if (inameRef.value && idescRef.value && ivendorRef.value) {
      console.log(inameRef.value);
      this.props.addItem(inameRef.value, idescRef.value, ivendorRef.value);
      inameRef.value = idescRef.value = ivendorRef.value = '';
    }
  }

  render() {
    return (
      <div>
        <form>
          <p>Name:
            <input placeholder="Cool Item" ref="iname"/>
          </p>
          <p>Description:
            <input placeholder="A really cool item" ref="idesc"/>
          </p>
          <p>Vendor:
            <input placeholder="Cool Corp" ref="ivendor"/>
          </p>
        </form>
        <button onClick={this.addItem}>Submit</button>
      </div>
    );
  }
}

ItemCreate.propTypes = {
  addItem: PropTypes.func.isRequired
}
