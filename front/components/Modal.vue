<template>
    <section>
        <b-modal :active="isModalForm"
                 has-modal-card
                 trap-focus
                 :destroy-on-hide="false"
                 aria-role="dialog"
                 width="1000"
                 :on-cancel="closeModal"
                 aria-modal>
        <div class="modal-card" style="width: auto">
          <component 
            :is="FormComponent"
            @isCloseModal="closeModal"
            @ChangeForm="$emit('ChangeForm', $event)"
            @ChangeImage="$emit('ChangeImage', $event)"
          >
          </component>
        </div>
      </b-modal>
    </section>
</template>

<script>
  import Login from '~/components/Login.vue'
  import SignUp from '~/components/SignUp.vue'
  import ImageUploadWithValidation from '~/components/Form/ImageUploadWithValidation.vue'
    export default {
        name: 'Modal',
        components: {
            Login,
            SignUp,
            ImageUploadWithValidation
        },
        props: {
            'isModalForm': {
            type: Boolean,
            required: true
        },
        'FormComponent': {
            type: String,
            required: true
        },
        },
        data() {
            return {
            }
        },
        methods: {
            closeModal () {
                this.$emit('isCloseModal', false)
            },
          
        }
    }
</script>

<style>
.modal-background {
background-color:rgba(255,255,255,.97);
}
</style>