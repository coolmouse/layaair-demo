class PointLightDemo{
    constructor(){
        this._temp_position = new Laya.Vector3();
        this._temp_quaternion = new Laya.Quaternion();
        Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(new Laya.Scene3D());
        this.scene.ambientColor = new Laya.Vector3(0.1, 0.1, 0.1);
        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000)));
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        //点光
        this.pointLight = this.scene.addChild(new Laya.PointLight());
        this.pointLight.color = new Laya.Vector3(1.0, 0.5, 0.0);
        this.pointLight.transform.position = new Laya.Vector3(0.4, 0.4, 0.0);
        this.pointLight.range = 3.0;
        Laya.Sprite3D.load("res/threeDimen/staticModel/grid/plane.lh", Laya.Handler.create(this, function (sprite) {
            var grid = this.scene.addChild(sprite);
            Laya.Sprite3D.load("res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Laya.Handler.create(this, this.loadSprite3D));
        }));
    }

    loadSprite3D(sp){
        this.scene.addChild(sp);
        var aniSprite3d = sp.getChildAt(0);
        var animator = aniSprite3d.getComponent(Laya.Animator);
        var state = new Laya.AnimatorState();
        state.name = "attack";
        state.clipStart = 75 / 150;
        state.clipEnd = 110 / 150;
        state.clip = animator.getDefaultState().clip;
        animator.addState(state);
        animator.play("attack");
        Laya.timer.frameLoop(1, this, this.onFrameLoop);
    }

    onFrameLoop(){
        Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._temp_quaternion);
        Laya.Vector3.transformQuat(this.pointLight.transform.position, this._temp_quaternion, this._temp_position);
        this.pointLight.transform.position = this._temp_position;
    }
}


//激活启动类
new PointLightDemo();
