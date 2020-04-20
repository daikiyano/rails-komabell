<template>
    <h1>{{ name }}</h1>
   
</template>

<script>

    export default {
//         methods: {
//     getMsg (params) {
//         a =$route.params.id
//       this.$axios.$get(`http://back:3000/users/${params.id}`).then(res => (

//           console.log("hello")
//       ))
//     }
//   },
        asyncData({ $axios, params }){
            return $axios.$get(`/api/users/${params.id}`)
            .then(( res ) => {
                return { name: res.name }
            })
        }

//         async asyncData({ $axios ,params}) {
//   const response = await $axios.$get(`http://back:3000/users/${params.id}`)
//     .catch( error => {
//       console.log("response error", error)
//       return false
//     })
//   return { data: response.data }
// }
    }
</script>