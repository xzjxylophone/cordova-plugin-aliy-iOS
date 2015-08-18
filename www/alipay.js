var exec = require('cordova/exec');

/**


navigator.alipay.pay("a long long long string",function(msgCode){alert(msgCode)},function(msg){alert(msg)})


**/

module.exports = {
    pay: function(orderInfo,onSuccess,onError){
        exec(onSuccess, onError, "Alipay", "pay", [orderInfo]);
    }
};