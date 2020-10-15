export const state = () => ({
    hey: ''
   })

//    export const actions = {
//         add({commit}, value) {
//             commit('StatusSignup', value)
//         }
//     }
   
   export const mutations = {
   
    status(state) {
      state.hey = 'test'
    }
   }