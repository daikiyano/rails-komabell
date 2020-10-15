<template>
  <div style="margin-buttom: 300px;">
    <section class="section" style="text-align: center;">
    <main style="top: 50px; position: relative;">
      <h1 class="title is-3">
      <b-icon
        icon="book-open-variant"
        size="is-medium"
      />
      プログラミング学習サービス一覧
    </h1>
      <div v-for="(site, index) in this.sites" :key="index" style="height: 260px; width:360px; box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
        <nuxt-link :to="`/sites/${site.id}`">
          <h1 class="title is-6">{{site.title}}</h1>
          <img class="is-rounded" :src="files[index]" alt="Image" style="">
        </nuxt-link>  
        <!-- {{ site.title }} -->
        <!-- <h1 class="title is-5">利用価格 : {{ site.price }}</h1>
        <h1 class="title is-5">レベル : {{ site.difficulty_level }}</h1>
        {{ site.difficulty_level }}
        <h1 class="title is-5">サービス概要</h1>
        {{ site.description }}  -->
        <!-- {{ site.url }}  -->
       
      </div>
     
    </main>
    </section>
  </div>
</template>

<script>


 export default {
    components: {

    },
    data() {
      return {
          sites : "",
          files : null
    }
    },
    created () {
      this.FetchSites()
    },
  methods: {
      FetchSites () {
            this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get('/api/v1/sites')
            .then(res => {
           
             this.sites = res.data
             this.files = res.images

            //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
             console.log(res)
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
    
        }
    
  }
 
</script>
