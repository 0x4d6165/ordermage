import React, {PropTypes} from 'react';
import { Link, IndexLink } from 'react-router';

const Header = () => {
  return (
    <div>
      <h1>Ordermage</h1>
      <nav>
        <IndexLink to="/">Home</IndexLink>
        {" | "}
        <Link to="/orders">Orders</Link>
        {" | "}
        <Link to="/items">Items</Link>
        {" | "}
        <Link to="/cart">Cart</Link>
      </nav>
    </div>
  );
};

export default Header;
