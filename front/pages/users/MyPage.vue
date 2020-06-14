<template>
<div>
    <MyPageTab/>
           <h1>基本情報</h1>

   <div class="box">
  <article class="media">
    <div class="media-left">
      <figure class="image is-64x64">
        <img class="is-rounded" :src="image" alt="Image">
      </figure>
      <b-button class="button" type="is-dark" @click="OpenModal">アップロード</b-button>
    </div>
    <Modal :isModalForm="this.isModalForm" 
        :FormComponent="this.FormComponent"   
        @isCloseModal="closeModal" 
        @ChangeImage="ChangeImage($event)" 
        @UploadImage="UploadImage()" 
    />
  
    <div class="media-content">
      <div class="content">
        <p>
          <strong>ユーザー名:{{user.username}}</strong>  <small>性別:31m</small>
          <br>
          <!-- <img :src="user" alt=""> -->
          {{user.description}}
        </p>
      </div>
       <section>
         <h2><strong>保有技術</strong></h2>
         <div v-for="(tag, index) in this.SkillTags" :key="index">
            <b-tag style="float: left; margin: 10px 10px;">{{tag.tag_name}}</b-tag> 
       
        <b-field :label="tag.tag_name">
              <b-slider type="is-success" 
                    :min="0" :max="4" 
                    :value="tag.skill" 
                    :tooltip="false" 
                    :aria-label="tag.tag_name" 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                    >
                    
                 <b-slider-tick :value="0">0</b-slider-tick>
                <b-slider-tick :value="1">25</b-slider-tick>
                <b-slider-tick :value="2">50</b-slider-tick>
                <b-slider-tick :value="3">75</b-slider-tick>
                <b-slider-tick :value="4">100</b-slider-tick>
              </b-slider>
            </b-field>
           </div>
    </section>

      <!-- <nav class="level is-mobile">
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
      </nav> -->
    </div>
  </article>
</div>
   
</div>
</template>

<script>
import MyPageTab from '~/components/users/MyPageTab.vue'
import Modal from '~/components/Modal.vue'
import ImageUploadWithValidation from '~/components/Form/ImageUploadWithValidation.vue'



export default {
    components: {
        MyPageTab,
        Modal,
        ImageUploadWithValidation
    },
    data() {
        return {
        user : "",
        image : "",
        email : "",
        SkillTags : [],
        croppieImage: '',
        file : "",
        cropped: null,    
        user : "",
        isModalForm : false,
        FormComponent : "",
          form : {
            file : null       
          },
        
        }
    },
    created() {
       this.fetchUser()
       this.FetchUserSkills()
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
                 this.user = response.user
                 this.image = response.image
             }) 
             
        },
        FetchUserSkills () {
          this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get('/api/v1/myskill/user_skill_categories/index')
            .then(res => { 
             this.SkillTags = res.data
            //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
             console.log(this.SkillTags)
            })
            .catch ( error => {
                if (error.response.status == "401") {
                    console.log("tokenが無効です")
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内でも問題が発生しました',
                        type: 'is-danger'
                    })
                }
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
        },
        OpenModal () {
          this.isModalForm = true
          this.FormComponent = "ImageUploadWithValidation"
        },
        closeModal () {
            this.isModalForm = false
        },
        ChangeImage(image) {
            console.log("hey")
            
            this.form.file = image
            console.log(this.form)
        },
        UploadImage(image) {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            var formData = new FormData();
            formData.append('user[image]', this.form.file );

            if(this.form.file) {
            this.$axios.$put('/api/v1/mypage/user_images',formData,{ 
                headers: {
                    'Content-Type': 'multipart/form-data'
                } 
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '画像アップロードが完了しました',
                    type: 'is-success'
                })
                this.$router.push('/users/mypage')
                this.isModalForm = false
                this.fetchUser()
                 console.log(response)
            })
            .catch ( error => {
                if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                    console.log("tokenが無効です")
                        // this.error = "Tokenが無効です"
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内で問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
            }
        }
    }
}

</script>

// myPageStatus='"MySkills"'