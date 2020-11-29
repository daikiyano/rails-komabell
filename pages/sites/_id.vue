<template>
<div class="is-centered">
  <section class="hero is-dark">
    <div class="hero-body">
      <div class="container">
        <h1 class="title">
          {{ site.title }}
        </h1>
        <h2 class="subtitle">
          コースレベル<b-tag type="is-light">{{ site.difficulty_level }}</b-tag>
        </h2>
      </div>
    </div>
  </section>
<div class="box">
  <article class="media">
  <div style="margin-buttom: 300px;">
      <star-rating 
            v-bind:increment="0.5"
            v-bind:read-only="true"
            v-bind:max-rating="5"
            v-bind:show-rating="false"
            v-bind:rating="this.average"
            v-bind:star-size="30">
        </star-rating>
    <div class="columns is-centered">
     <!-- is-mobile  -->
      <div class="column is-10">
        <img :src="file" alt="TOP本" style="display: block;"> 
      </div>
    </div>
    <div v-if="IsFavorite === true && this.$auth.loggedIn">
      <b-button @click="DeleteSiteFavorite()" type="is-info">お気に入り解除する</b-button>
    </div>
    <div v-else-if="IsFavorite === false && this.$auth.loggedIn">
      <b-button type="is-info" @click="PostSiteFavorite()" style="">お気に入り登録する</b-button>
    </div>
    <div v-else>
      <b-button type="is-info" @click="isModalForm=true; FormComponent='Login'">お気に入り登録する</b-button>
    </div>
    <h1 class="title is-4">公式サイト</h1>
    {{ site.url }}
    <h1 class="title is-4">学べる技術</h1>
      <div v-for="tag in siteTags" :key="tag.id" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline; margin: 10px 20px; text-align: center;">
        <b-tag>{{tag.tag_name}}</b-tag>
      </div>
      <h2>利用価格</h2>
      {{ site.price }}
      <h1 class="title is-4">レベル</h1>
      <p>
        <b-tag type="is-light">{{ site.difficulty_level }}</b-tag>
      </p>
      <h1 class="title is-5">サービス概要</h1>
      {{ site.description }}  
        <!-- <nuxt-link :to="`/admin/sites/${site.id}/edit`">
          編集
        </nuxt-link>  -->
      <h1 class="title is-5">{{site.title}} のレビュ一覧</h1>
      <div v-if="comments.length > 0">
        <div v-for="(comment, index) in this.comments" :key="index">
          <article class="media">
            <div class="media-left">
              <p class="image is-64x64">
                <img class="is-rounded" :src="images[index]" alt="Image">
              </p>
            </div>
            <div class="media-content">
              <div class="content">
                <p>
                  <strong>
                    @{{comment.username}}
                  </strong>
                  <br>
                  <star-rating 
                        v-bind:increment="0.5"
                        v-bind:read-only="true"
                        v-bind:max-rating="5"
                        v-bind:show-rating="false"
                        v-bind:rating="comment.review"
                        v-bind:star-size="20">
                  </star-rating><br>
                  {{comment.comment}}<br>
                  {{ $moment(comment.created_at).fromNow() }}
                  <span v-if="comment.user_id === currentUser.id" @click="DeleteSiteComment(comment.id,index)">
                    <b-icon icon="trash-can-outline" size="is-small"></b-icon>
                  </span>
                </p>
              </div>
            </div>
          </article>  
        </div>
      </div>
   <div v-if="this.$auth.loggedIn" style="width: 100%; height: 400px;">
     
     <span style="color: red;">{{ErrorMessage}}</span><br>
     <ValidationObserver ref="observer" v-slot="{ passes }">
     <InputWithValidation
            rules="required|max:200" 
            label="評価コメント"
            type="textarea"
            vid="comment"
            v-model="comment"
            />
            <b-icon
                pack="fas"
                icon="tachometer-alt">
            </b-icon>
       </ValidationObserver>
      <!-- <b-field label="評価コメント">
          <b-input v-model="comment" maxlength="200" type="textarea"></b-input>
        </b-field>  -->
        <b-field label="評価">
          <star-rating 
            @rating-selected="setRating"
            v-bind:increment="0.5"
            v-bind:max-rating="5"
            v-bind:show-rating="false"
            v-bind:star-size="30">
          </star-rating>
        </b-field>
          <b-button type="is-light" size="is-small" @click="PostSiteComment()">コメントする</b-button>
      </div>
  </div>
    </article>
</div>
<Modal 
      :isModalForm="this.isModalForm" 
      :FormComponent="this.FormComponent"   
      @isCloseModal="closeModal" 
      @ChangeForm="ChangeForm($event)" 
    />
</div>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import InputWithValidation from "~/components/Form/InputWithValidation.vue";
import Login from '~/components/Login.vue'
import SignUp from '~/components/SignUp.vue'
import Modal from '~/components/Modal.vue'

  import StarRating from 'vue-star-rating'


 export default {
    components: {
        StarRating,
        ValidationObserver,
        ValidationProvider ,
        InputWithValidation,
        Login,
        SignUp,
        Modal

    },
    data() {
      return {
        site : "",
        file : null,
        comment : "",
        rating : '',
        site_id : this.$route.params.id,
        comments : {},
        images : [],
        currentUser :"",
        average : "",
        IsFavorite : null,
        ErrorMessage : "",
        siteTags: [],
        isModalForm : false,
        FormComponent : ""
      }
    },
    created () {
     this.fetchSite()
     this.FetchSiteComments()
     this.fetchUser()
     this.FetchUserLike()
    },
    methods: {
        async fetchUser () {
      if (localStorage.idToken) {
        const ret = await this.$axios.$get('/api/v1/auto_login',{ 
          headers:{"Authorization" :`Bearer ${localStorage.idToken}`
          }
             })
             .then(response => {
                 console.log(response)
                 this.currentUser = response.user
                 this.image = response.image
             }) 
      }
        },
            
        fetchSite () {
          const loadingComponent = this.$buefy.loading.open()
        const id = this.$route.params.id
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
        this.$axios.$get(`/api/v1/sites/${id}`)
        .then(res => {
        console.log(res.data)
        console.log(res)
        this.site = res.data
        this.file = res.image
        this.siteTags = res.site_tags
        loadingComponent.close()

        })
    .catch ( error => {
      if (error.response.status == "404") {
          console.log("書籍が見つかりません")
          this.$buefy.toast.open({
            duration: 5000,
            message: '書籍が見つかりません',
            type: 'is-danger'
          })
      }
    })
    },
     PostSiteComment() {
      if(this.comment && this.rating) {
          const site_id = this.$route.params.id
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}` 
        this.$axios.$post(`/api/v1/sites/${site_id}/site_comments`, {
        site_comment : {
          comment : this.comment,
          review : this.rating
        }
      })
        .then(res => {
          console.log(res)
          console.log(res.data)
          let comments = res.data
          comments.username = this.currentUser.username
          this.images.push(this.image);
          this.comments.push(comments);
          this.comment = ""
          
          this.$buefy.toast.open({
              duration: 1000,
              message: 'レビューコメントを投稿しました',
              type: 'is-info'
            })
            // redirect()
            redirect(`/sites/${this.$route.params.id}`)
            // return redirect(`/sites/${this.$route.params.id}`)
            // this.$router.push(`/sites/${this.$route.params.id}`)
          })
      .catch ( error => {
        if (error.response.status == "401") {
            this.$buefy.toast.open({
              duration: 5000,
              message: 'サーバー内でも問題が発生しました',
              type: 'is-danger'
            })
        }
      })  
      } else {
        this.ErrorMessage = "コメントと評価を入力してください"
      } 
      },
      setRating (rating) {
        
      this.rating = rating
    },
    FetchSiteComments () {
      const site_id = this.$route.params.id
      this.$axios.$get(`/api/v1/sites/${site_id}/site_comments`)
      .then(res => {
        console.log(typeof(res.review))
        console.log("hey")
        this.comments = res.data
        this.images = res.images
        this.average = res.review


        })
    .catch ( error => {
      if (error.response.status == "404") {
          console.log("書籍が見つかりません")
          this.$buefy.toast.open({
            duration: 5000,
            message: '書籍が見つかりません',
            type: 'is-danger'
          })
      }
    })
      
    },
    DeleteSiteComment(comment_id,index) {
      console.log(`comment_id : ${comment_id}`)
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$delete(`/api/v1/sites/${this.$route.params.id}/site_comments/${comment_id}`)
    //  /api/v1/sites/:site_id/site_comments/:id
      .then(res => {
        console.log(res)
        this.comments = this.comments.filter(comment => {
          // コメント削除
          return comment.id != comment_id
        })
        this.images = this.images.filter((image,id) => {
          // 画像削除
          console.log(index,id)
          return id != index
        })
        this.$buefy.toast.open({
            duration: 1000,
            message: 'コメントを削除しました',
            type: 'is-info'
          })
          this.$router.push(`/sites/${this.$route.params.id}`)
        })
    .catch ( error => {
      if (error.response.status == "401") {
        this.$buefy.toast.open({
          duration: 5000,
          message: 'サーバー内で問題が発生しました',
          type: 'is-danger'
        })
      }
    })
    
    },
    PostSiteFavorite () {
      console.log("hey")
this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$post(`/api/v1/sites/${this.$route.params.id}/site_favorites`, {
        // site_favorites : {
        //   isbn : lsbn,
        //   imageurl : imageurl
        // }
     })
      .then(res => {
        console.log(res.data)
        this.IsFavorite = true
        this.$buefy.toast.open({
            duration: 1000,
            message: 'お気に入り登録しました',
            type: 'is-info'
          })
        })
    .catch ( error => {
      if (error.response.status == "401") {
          this.$buefy.toast.open({
            duration: 5000,
            message: 'サーバー内でも問題が発生しました',
            type: 'is-danger'
          })
      }
    })
    },
    DeleteSiteFavorite () {
      console.log("hey")
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$delete(`/api/v1/sites/${this.$route.params.id}/site_favorites`)
      .then(res => {
        console.log(res)
        this.IsFavorite = false
        this.$buefy.toast.open({
            duration: 1000,
            message: 'お気に入りを解除しました',
            type: 'is-info'
          })
        })
    .catch ( error => {
      if (error.response.status == "401") {
          this.$buefy.toast.open({
            duration: 5000,
            message: 'サーバー内でも問題が発生しました',
            type: 'is-danger'
          })
      }
    })
    },
    FetchUserLike () {
      if (this.$auth.loggedIn) {
        this.$axios.$get(`/api/v1/sites/${this.$route.params.id}/site_favorites`)
          .then(res => {   
            console.log(res.data)  
            if (res.data === true) {
              this.IsFavorite = true
            } else {
              this.IsFavorite = false
            }
          })
          .catch ( error => {
            if (error.response.status == "401") {
              this.$buefy.toast.open({
                duration: 5000,
                message: 'サーバー内でも問題が発生しました',
                type: 'is-danger'
              })
            }
        })
      }
    },
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    },
  } 
}
 
</script>

