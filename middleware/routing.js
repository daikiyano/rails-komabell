
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

