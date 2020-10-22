<template lang="pug">
  #dadata
    q-dialog(v-model="qDldDadata" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="onAddDadata" @reset="reset")
            q-select(filled v-model="dadata_company" clearable use-input hide-selected fill-input
            input-debounce="300" label="Autoselect after filtering" :options="dadata_options"
              option-label="name"
              @filter="filterFnAutoselect"  @filter-abort="abortFilterFn" style="width: 300px")
            template(v-slot:no-option)
              q-item
                q-item-section(class="text-grey") No results
            q-btn(label="Add" type="submit" color="primary")
            q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
            q-btn(flat label="Cancel" color="primary" v-close-popup)
</template>

<script>
export default {
  data() {
    return {
      dadata_companies: [],
      dadata_options: [],
      dadata_company: '',
      errors: []
    }
  },
  props: ['dadata_new'],
  methods: {
    onAddDadata() {
      this.$emit('dadata_company', (Object.assign({},this.dadata_company)));
      this.reset();
    },
    reset(){
      this.dadata_options = [];
      this.dadata_company = '';
      this.dadata_companies = [];
    },
    async getDadataCompanies(filter) {
      try {
        this.dadata_companies = [];
        let dadata_filter = {
          query: filter
        };
        const response = await this.$api.dadata.index(dadata_filter);
        response.data.suggestions.forEach(element => {
          let company = {};
          company.name= element.data.name.full;
          company.inn = element.data.inn;
          company.ogrn = element.data.ogrn;
          this.dadata_companies.push(Object.assign({},company));
          }
        )
        this.dadata_options = this.dadata_companies.filter(company => company.name.toLowerCase().indexOf(filter.toLowerCase()) > -1);
      } catch(err) {
        this.errors.push(err);
      };
    },
    filterFnAutoselect (val, update, abort) {
      // call abort() at any time if you can't retrieve data somehow
      update(
        () => {
          if (val.length > 0) {
            this.getDadataCompanies(val);
          } else {
            this.dadata_options = (Object.assign([], this.dadata_companies));
          }
        },
        ref => {
          if (val !== '' && ref.options.length > 0 && ref.optionIndex === -1) {
            ref.moveOptionSelection(1, true) // focus the first selectable option and do not update the input-value
            ref.toggleOption(ref.options[ref.optionIndex].name, true) // toggle the focused option
          }
        }
      )
   },

    abortFilterFn () {
    }
  },
  computed: {
    qDldDadata: {
      // getter
      get() {
        return this.dadata_new;
      },
      // setter
      set(val) {
        this.$emit("update:dadata_new", val);
      }
    }
  }
}
</script>

<style scoped>
</style>
