import http from '@/utils/request'

/**
 * 查询镇村列表
 * @param params
 * @returns
 */
export default {
  async getHouseholdList(params) {
    return http.get("/api/household/getHouseholdList", params);
  },

  async getHouseholdListById(params) {
    return http.get("/api/household/getHouseholdListById", params);
  }
}
