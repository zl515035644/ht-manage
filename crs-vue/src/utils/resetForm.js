export default function resetForm(fromName,obj) {
  if (this.$refs[fromName]){
    this.$refs[fromName].resetFields();
  }
  Object.keys(obj).forEach(key => {
    obj[key] = '';
  })
}
