import React from "react";
import "../stylesheets/main.scss";
import Header from './Header.js';

// app component
export default class App extends React.Component {
  // render
  render() {
    return (
      <div className="container">
        <Header/>
        {this.props.children}
      </div>
    );
  }
}
