<template>
<div>

    <b-tabs type="is-toggle" :value="activeTab" @input="StatusMyPage" expanded>
        <b-tab-item label="マイページ" icon="account-box"></b-tab-item>
        <b-tab-item  label="編集" icon="account-cog-outline"></b-tab-item>
        <b-tab-item label="マイスキル" icon="video"></b-tab-item>
    </b-tabs>
   
</div>
</template>

<script>

export default {
  name: 'MyPageTab',
  props: {
    'activeTab': {
      type: Number
    }
  },
  data() {
    return {
      
    }
    
  },
  created() {
    },
    methods: {
        
       
        StatusMyPage(status) {
            if (status === 0) {
                this.$router.push('/users/mypage')
            } else if (status === 1) {
                // this.MyPageComponent = "Edit"
                this.$router.push('/users/edit')
            }　else if (status === 2) {
              this.$router.push('/users/myskill')
               
            }
        }
    }
    
}

</script>