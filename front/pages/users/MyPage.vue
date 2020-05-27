<template>
<div>
    <h1>My page</h1>
        <MyPageTab/>

   {{user.email}}
   <!-- <component :is="MyPageComponent" :user="this.user"></component> -->
   
</div>
</template>

<script>
import MyPageTab from '~/components/users/MyPageTab.vue'
// import Edit from '~/components/users/Edit.vue'
// import MySkill from '~/components/users/MySkill.vue'



export default {
    components: {
        MyPageTab
        
    },
    data() {
        return {
        user : "",
        email : "",
        }
    },
    created() {
       this.fetchUser()
    },
    methods: {
        // ユーザー情報取得
        async fetchUser () {
            const ret = await this.$axios.$get('/api/v1/auto_login',{ 
                headers:{"Authorization" :`Bearer ${localStorage.idToken}`
                }
             })
             .then(res => {
                 console.log(res)
                 this.user = res
                 this.email = res.email
             }) 
             
        },
       
        StatusMyPage(status) {
            if (status === 0) {
                this.MyPageComponent = "MyPage"
            } else if (status === 1) {
                // this.MyPageComponent = "Edit"
                this.$router.push('/users/edit')
            }　else if (status === 2) {
                this.MyPageComponent = "MySkill"
            }
        }
    }
}

</script>

// myPageStatus='"MySkills"'