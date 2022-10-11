import React from "react";

const Products = (props) => {
	return (
		<div className="container">
			<div className="cards">
				<div className="row mt-5">
					{props.products.map((pro) => (
						<div className="col-md-4" key={pro.index}>
							<div className="card text-center mt-5">
								<img
									src={pro.url}
									alt="img"
									className="card-img-top"
								/>

								<div className="card-body text-dark">
									<h4 className="card-name">
										Product location: {pro.location}
									</h4>
                  <li class="list-group-item">service Option: {pro.serviceOption}</li>
    <li class="list-group-item">phone: {pro.phone}</li>
    <li class="list-group-item">price {pro.price /  1000000000000000000}cUSD</li>
									<div>
                  
											<a
												href="/#"
												className="btn btn-outline-success btw"
												onClick={() =>
													props.buyProduct(pro.index)
												}
											>
												Buy Product
											</a>
                      
								 
 
									  <div>
												<button
													type="button"
													className="btn btn-outline-dark btw"
													onClick={() =>
														props.UnlistProduct(
															pro.index
														)
													}
												>
												 Unlist Product
												</button>
                        </div>
                      
											 
									 
									</div>
								</div>
							</div>
						</div>
					))}
				</div>
			</div>
		</div>
	);
};

export default Products;