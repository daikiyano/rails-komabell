<template>
<div>
    <MyPageTab/>
           <h1>基本情報</h1>

   <div class="box">
  <article class="media">
    <div class="media-left">
      <figure class="image is-64x64">
        <img :src="image" alt="Image">
      </figure>
    </div>
    <div class="media-content">
      <div class="content">
        <p>
          <strong>ユーザー名:{{user.username}}</strong>  <small>性別:31m</small>
          <br>
          <!-- <img :src="user" alt=""> -->
          {{user.description}}
        </p>
      </div>
      <nav class="level is-mobile">
        <div class="level-left">
          <a class="level-item" aria-label="reply">
            <span class="icon is-small">
              <i class="fas fa-reply" aria-hidden="true"></i>
            </span>
          </a>
          <a class="level-item" aria-label="retweet">
            <span class="icon is-small">
              <i class="fas fa-retweet" aria-hidden="true"></i>
            </span>
          </a>
          <a class="level-item" aria-label="like">
            <span class="icon is-small">
              <i class="fas fa-heart" aria-hidden="true"></i>
            </span>
          </a>
        </div>
      </nav>
    </div>
  </article>
</div>
   
</div>
</template>

<script>
import MyPageTab from '~/components/users/MyPageTab.vue'



export default {
    components: {
        MyPageTab
        
    },
    data() {
        return {
        user : "",
        image : "",
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
             .then(response => {
                 console.log(response)
                 this.user = response.session_user
                 this.image = response.image
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