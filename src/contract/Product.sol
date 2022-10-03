 // SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
contract Thriftly {
    uint private thriftsLength = 0;
    address internal cUsdTokenAddress =
        0x686c626E48bfC5DC98a30a9992897766fed4Abd3;

    struct Thrift {
        address payable creator;
        string url;
        string location;
        string serviceOption;
        uint phone;
        uint price;
      
    }
     mapping(uint => Thrift) internal thrifts;

     modifier onlyCreator (uint256 _index) {
         require(msg.sender == thrifts[_index].creator,
         "only the creator can access this function"
         );
          _;
     }

     
    function getProduct(uint _index)
        public
        view
        returns (
            address payable creator,
            string memory url,
            string memory location,
            string memory serviceOption,
            uint phone,
            uint price
            
        )
    {
        creator = thrifts[_index].creator;
        url = thrifts[_index].url;
        location = thrifts[_index].location;
       serviceOption  = thrifts[_index].serviceOption;
        phone = thrifts[_index].phone;
        price = thrifts[_index].price;
      
    }

    
      function buyProduct(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            thrifts[_index].creator,
            thrifts[_index].price
          ),
          "Transfer failed."
        );

         thrifts[_index].creator = payable(msg.sender);
         
    }

     function  addProduct(
        string memory _url, 
         string memory _location, 
        string memory _serviceOption,
        uint _phone,
        uint _price

          ) public {
       Thrift storage thriffs= thrifts[thriftsLength];


         thriffs.creator = payable(msg.sender);
        thriffs.url = _url;
        thriffs.location = _location;
         thriffs.serviceOption = _serviceOption;
          thriffs.phone = _phone;
          thriffs.price = _price;
         
thriftsLength++;
          }

           function getThriftsLength() public view returns (uint) {
      return thriftsLength;
    }

}