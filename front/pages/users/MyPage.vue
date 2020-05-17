<template>
<div>

    <h1>My page</h1>
    <b-tabs type="is-toggle" @input="StatusMyPage" expanded>
        <b-tab-item label="マイページ" icon="account-box"></b-tab-item>
        <b-tab-item label="編集" icon="account-cog-outline"></b-tab-item>
        <b-tab-item @click="hey()" label="マイスキル" icon="video"></b-tab-item>
    </b-tabs>
   {{user.email}}
   <component :is="MyPageComponent" :email="this.email"></component>
   
</div>
</template>

<script>
import MyPage from '~/components/users/MyPage.vue'
import Edit from '~/components/users/Edit.vue'
import MySkill from '~/components/users/MySkill.vue'



export default {
    components: {
        MyPage,
        Edit,
        MySkill
    },
    data() {
        return {
        user : "",
        email : "",
        MyPageComponent : "MyPage"
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
                this.MyPageComponent = "Edit"
            }　else if (status === 2) {
                this.MyPageComponent = "MySkill"
            }
        }
    }
}

</script>

// myPageStatus='"MySkills"'