<template>
  <div style="margin-buttom: 300px;">
    <h2 class="title is-3">{{ site.title }}</h2>
    <img :src="file" alt="TOP本" style="display: block;"> 
        <h1 class="title is-5">利用価格 : {{ site.price }}</h1>
        <h1 class="title is-5">レベル : {{ site.difficulty_level }}</h1>
        {{ site.difficulty_level }}
        <h1 class="title is-5">サービス概要</h1>
        {{ site.description }}  
        {{ site.url }}
        <nuxt-link :to="`/admin/sites/${site.id}/edit`">
          編集
        </nuxt-link> 
       
   
  </div>
</template>

<script>


 export default {
    middleware: 'admin',
    components: {

    },
    data() {
      return {
          site : "",
          file : null,
          comments : {},
          images : [],
         
    }
    },
    created () {
     this.fetchSite()
    },
    methods: {
        fetchSite () {
        const id = this.$route.params.id
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
        this.$axios.$get(`/api/v1/admin/sites/${id}`)
        .then(res => {
        console.log(res.data)
        console.log(res)
        this.site = res.data
        this.file = res.image
        

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
     
    
        },

   
    
  }
 
</script>
