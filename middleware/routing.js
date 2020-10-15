
export default function({store,route}) {
    if (!store.state.auth.loggedIn && route.fullPath !== '/callback') {
     console.log(store.state.auth.loggedIn)
     localStorage.clear()
    //  this.$buefy.toast.open({
    //     duration: 5000,
    //     message: 'タイムアウトのためログアウトしました。再度ログインしてください。',
    //     type: 'is-danger'
    // })
    }
  }


//   <style>
// body {
//   font-family: "Helvetica Neue", Helvetica, sans-serif;
// }
// </style>
// <h1>Welcome to SyncFiddle</h1>
// <div >answer1: <span id='answer1'/></div>
// <div >answer2: <span id='answer2'/></div>
// <div >answer3: <span id='answer3'/></div>
// <script>
//   // arr1 === arr2 はインスタンスの比較なので必ずfalseになります。
//   // arr1 == arr2 も同様です。
//   // 別の方法での回答をお願いします。
// function ans(arr1, arr2) {
//   	for (let i = 0, l = arr1.length; i < l; i++) {
//   	  const result = Array.isArray(arr1[i]) ? ans(arr1[i], arr2[i]) : arr1[i] === arr2[i]
//     if (!result) return false
//     } 
//   return true
//     //for(let i in arr1) {
//       //  for(let t in arr2) {
//         //   if (arr1[i] !== arr2[i]){
//           //   return false;
//            //}
//         //}
//       //console.log(arr1[i])
//      //}
    
  
//   //if () {
//    //  return true;
//  // } else {
//   //  return false;
//  // }
//   //console.log(arr1)
//   //console.log(arr2)
// }

// const a = [1,2,[3,[4,5]]];
// const b = [1,2,[3,[4,5]]];
// console.log(ans(a,b)); // true
// document.getElementById('answer1').innerHTML = `${ans(a,b)}`;
// const c = [1,3, [3,4]];
// const d = [1,2, [3,4]]; 
// console.log(ans(c,d)); //false
// document.getElementById('answer2').innerHTML = `${ans(c,d)}`;
// const e = [1,2, [3,4]];
// const f = [1,2, [4,4]];
// console.log(ans(e,f)); // false
// document.getElementById('answer3').innerHTML = `${ans(e,f)}`;
// </script>