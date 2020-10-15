export const state = () => ({
    status: ''
   })


   export const mutations = {
   
    status(state,value) {
        console.log(value)
      state.status = value
    }
   }