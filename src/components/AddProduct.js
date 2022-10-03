import React from 'react'

import { useState } from "react";

const AddProducts = (props) => {
const [url, setUrl] = useState('');
 const [location, setLocation] = useState('');
 const [serviceOption, setServiceOption] = useState('');
 const [phone, setPhone] = useState();
 const [price, setPrice] = useState();

 const submitHandler = (e) => {
    e.preventDefault();

    if(!url || !location || !serviceOption || !phone || !price) {
        alert('Please fill up the form')
        return

    }
    props.addProduct(url, location, serviceOption, phone, price);
    
    setUrl('')
    setLocation('')
    serviceOption('')
    setPhone('')
    setPrice('')
};

return(
    <form className='YR' onSubmit={submitHandler}>
    <div class="form-row" >
      
        <input type="text" class="form-control" value={url}
             onChange={(e) => setUrl(e.target.value)} placeholder="Image url"/>

<input type="text" class="form-control mt-4" value={location}
           onChange={(e) => setLocation(e.target.value)} placeholder="Product Address"/>

<input type="text" class="form-control mt-4" value={serviceOption}
           onChange={(e) => setServiceOption(e.target.value)} placeholder="Input Service Option"/>

 

<input type="text" class="form-control mt-4" value={phone}
           onChange={(e) => setPhone(e.target.value)} placeholder="Enter phone  number"/>
           
           <input type="text" class="form-control mt-4" value={price}
           onChange={(e) => setPrice(e.target.value)} placeholder="Enter price"/>

<button type="submit" class="btn btn-outline-dark lk">Add Product</button>

</div>
</form>
  
)
}
export default  AddProducts;
   