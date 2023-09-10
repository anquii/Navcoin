struct RawTransactions {
    static let hexEncodedNonSegWit = """
    2100000001b14bdcbc3e01bdaad36cc08e81e69c82e1060bc14e518db2b49aa43ad90ba26000000000490047304402203f16c6f40162ab686621ef3000b04e75418a0c0cb2d8aebeac894ae360ac1e780220ddc15ecdfc3507ac48e1681a33eb60996631bf6bf5bc0a0682c4db743ce7ca2b01ffffffff01ffffffffffffff7f03000000000000001976a914660d4ef3a743e3e696ad990364e555c271ad504b88ac01b8363724d6bf8ec759203e6ece2b6ef42e28fb2a4f0334cef9bd46aa4d6b17fbfad841d7e4ca2a9b70efef90cd6bfe9b068006fedc482aa77be0c735e62684f3468923a8d67ca7b9a37ed14959f0b445bdc9d2b9106eb8f487e4e3da643621c846b4279f50d36baebe2b157c6fe53118d8b8f0dd6ca452edabe9e9514a074eabafe141dc33db7fc70d9734171f1224938a810c505c9af6ba090e5ce694b92b13e297e61ed0cb547887bd610b46aa6eb0f7fb390d382b8276254358bd6ba5d6080aab4e747b61cee06b43ff297713c6438064051b7b8311ead621abcbdc5e64c09a01bc6d490d7665a4a336100f062aebcc943ef11a8e1498e5bd28e551616d1a8a12b21fe4188759f0b250f8bc848ed0972c32efa4cb1e0eae35dda287761761ff8a2813611092f99dda691631bf671071eb34cd2dc1eef2e396d06bceaa01522b1c0fdfdc6986ea42e8618fa836e1b02806b9b7e83e46efd71c738d490104a376cc7d90e7a6ea4a53af927107a5a6deadbb921ddd035ffc03d0cb5b3ec5ad6c3271b80d73b7b2fd19b6bee5fbac27a377748cc1014a119d328cef72e2aca7ee6268d8b707baba86659eac60e5019267c8db91a1dde859b5350263e2e3b7ea282e3eb7ce2da20b85896e1a8cfba2e2bcf6bf18c12edf27a04bc498756a7b4db6072da8f14979a8727786a6eca97427a32fc1a154abacbef24408f5d0054a0eec746d58a64a6ee7f1f4528b1cf2e49ada6831ad5a1d75eafc185d5f2e04ea3226cd7e51a337c7726c01c50ec7cc1abcb826dbfabda285e37565f0c4839fdf05e6ecac8093b9f65fd89ecbc8e848ce8f4200af8a563213eabb398dcb77ac8916dad7499eef1fb674bda30383cac8c67e235e6eb18e1094aa05f973dd4bb1804cfee5c913f1c7f512cd303e3163d1aeb3173585e088a24ca850b4e042ad6b93dbe0e15cb048be8e286bd45f2d45a837245b670197a11f0de9ee2771cff6e43f620496a94282f4b70b53f540280f81dc51b10ca682bba46977245baeeb4b8a3aa532251d54aeaeffdf59355736291ff4d4db6e1778ef34361a1b0a1ed2f43f1d21a64d348ca39861334bfcc1296e2ccaf2dcb2a3710663cb8959f41dff8641d33f6240b2eeb61f20e375099460d725df474a0554427f34638862247c51b289563ccf141341bfbea14e10e2a01a748323d4f96a206a53282a43b2054dd168d00d81f5e5349b2b039b261e320149e7de8c6884e86d5ca1fee2a98af40879b6356b5c6cee1ac2ef702e4c22ddf7810505d66e1f08e735dfed00845164d67a94670cf4ca4fe1f16ea1076a2e8d3b6f4a5b38086644771bec6ed42c96dba2eb778fde0608caa78b89845983334b532bec99bd96a2059c958dca246ff9ddf516fec76a47f05686cc15a9668bdd687052abbee581e26083b5831411f0c110b019f8a600ed431f00b79bbc131bf99c5ac77573b56b98b656b5fcef8479784dfdcd2e8d6ae253af53b651109ab069a0e9e59bb75774a2145d978bcae0561566981d2c72e969261849db2fb880ce6978e5d3833d769b7035dc387ffe865e238649eeadaad1b427a42800007b00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff00000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    """
    static let hexEncodedSegWit = """
    21000000000101000100000000000000000000000000000000000000000000000000000000000000000000171600144c9c3dfac4207d5d8cb89df5722cb3d712385e3fffffffff01ffffffffffffff7f03000000000000001976a9144c9c3dfac4207d5d8cb89df5722cb3d712385e3f88ac01807e0bd44065a46334e43abfdf67285171ec01f41e717c1e8466815693a43ca91abe809480f3202ddb53bb72532edc95069114c12949a851b57ed8304d4b72d85708e6bc7695851d858cfc821473d5bc2c023ee327dace06beed35c4ab87e427818e7615ccf5a5d9f3226c7e15a267632327979a3d6e9f77c9350af4f586984d9625e059120ff5cda95144e0992e4f9de59866ababf42b07614ab14a5759540d580f6094d6ce6a1783a6a690224ff8619f9048c5cb4b16b368b1671edb801e3c09828b9758ff3645175af97242e8ccea0f6d9600de6940e1d7a963b3e7c9798f1000448829f5835b4b028f9732608f1dcb894ee5723771331441f29a3c89ac9fa6c23ae24f9c9eccdf0e1992ae1876d9ded82bf2c5ebc4e66bfa89dc426d789f2395886c2ecbed1c8da8bcf0161bf1bdc3db7b5cd474c109392bec6957467cc76aa6da60922dce0f8430bfd791940cb4cd068c93ea263edb9e8738e4badb3fef1e38879194fe5a640d64d5b557739e79e3261c1c0dc61ed317220d24243f417cfdc0b923b44ae594fee35af4732e3d8147b15de6d56fa5f83c035981da08f0548815ad771e47012450b3acc397fa7c58e0f8b073bafef02860f2dabcd8c314d8c7479f86e585967a382c2bc597ab9078693f4b8f82677976997e7ddb0fd99c794750aab2b2ed9db2e2cc34d8fb9b835f37a09ab3ce0f28c37c95efc8e212ddd31d28d179ff87f16eb6f50907a9581f8263848fcfad58dec130c51cfc9a68ee45491a4c0fbf0823e7948f549360170abedcf9f650167ce3dbe20117bd4a2958c6bc3c81bb70cee61f1aaa23c71d8c67829340cdcc7f9972ce6eeed2dfb9c966512b1b0a25a1c7ab7051efda427df76ab82874856971b832e86b1a0e75d2b7ff5187ab95a9362c8ccaf29efd92bac81bd99d600f3db804c529684d26400e70ae4c6a748436541fbf6b223d556e648eb082145d0dac8a7140357d15aaa6db199ce1c98c319a8a47737cac132e5aa11a4db765ae960f0c2157636ce4952236460cb87c52f87e54e96416ffc839b4fe60742252f35a24d0169387f0823ab8792741d702acb8c81cc2bc5e56cb9f8dae3f276f2af1dd560e3b8ef933dc1ac4766eeb305a31094c1ca76d1e2665eea843b3690f29b239bd232e1d2b77d7a50cfaa48e05e307eb3d653aeda5ee9154f2bf0994aabef96c86805726ad7ed8095ed859433632c7c17e992dd2dd04ebbb6d0724a6d0e98e06456ef656b686e467240be4c6b5bf464b60bcd6366d5c073a83543688c805114c811716a56235f5cf70f7e82c1e7cc3374297f597205f50036630120c877ac348b2764041401766b7bd48227bfca86b8f68efd2e3567b90ed3d5d13d5a1bae8b754d949b4f8bfa5404bb1a45cd3c29c9211f1b12080fc6ccfcf8fc28dc04a05871fa3cf1629ef38446f564728a5cad08109cb270a0008c576f6422d2e7fb75e96aa40c41e8cc7e7ec76238e8b28f73184d5f4b54a549ab0d832c6f50703951e8bf1655d1107cd5f90032e4a172c82e5e23b0787aff49a5321d38b371c88573ef865a1f46808eddc6854b5eeaf24291700007b00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff02483045022100cfb07164b36ba64c1b1e8c7720a56ad64d96f6ef332d3d37f9cb3c96477dc44502200a464cd7a9cf94cd70f66ce4f4f0625ef650052c7afcfe29d7d7e01830ff91ed012103596d3451025c19dbbdeb932d6bf8bfb4ad499b95b6f88db8899efac102e5fc7100000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    """
    private init() {}
}
